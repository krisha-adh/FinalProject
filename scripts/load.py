import os
from pathlib import Path
import pandas as pd
from dotenv import load_dotenv
from sqlalchemy import create_engine, text

load_dotenv()

DB_HOST = os.getenv("DB_HOST", "localhost")
DB_PORT = os.getenv("DB_PORT", "5432")
DB_NAME = os.getenv("DB_NAME", "ecommerce_analytics")
DB_USER = os.getenv("DB_USER", "postgres")
DB_PASSWORD = os.getenv("DB_PASSWORD", "")
DB_SCHEMA = os.getenv("DB_SCHEMA", "ecommerce")

DATABASE_URL = f"postgresql+psycopg://{DB_USER}:{DB_PASSWORD}@{DB_HOST}:{DB_PORT}/{DB_NAME}"
ENGINE = create_engine(DATABASE_URL)

BASE_DIR = Path(__file__).resolve().parent.parent
CLEANED_DIR = BASE_DIR / "data" / "cleaned"


def load_csv_to_table(csv_filename: str, table_name: str, parse_dates: list[str] | None = None) -> None:
    csv_path = CLEANED_DIR / csv_filename
    if not csv_path.exists():
        raise FileNotFoundError(f"Missing cleaned file: {csv_path}")

    df = pd.read_csv(csv_path, parse_dates=parse_dates or [])
    df.to_sql(
        name=table_name,
        con=ENGINE,
        schema=DB_SCHEMA,
        if_exists="replace",
        index=False,
        method="multi",
        chunksize=500,
    )
    print(f"Loaded {len(df)} rows into {DB_SCHEMA}.{table_name} from {csv_filename}")


def main() -> None:
    with ENGINE.begin() as conn:
        conn.execute(text(f"CREATE SCHEMA IF NOT EXISTS {DB_SCHEMA};"))

    load_csv_to_table("products_cleaned.csv", "products", parse_dates=["created_at"])
    load_csv_to_table("users_cleaned.csv", "users", parse_dates=["birth_date"])
    load_csv_to_table("carts_cleaned.csv", "carts")
    load_csv_to_table("cart_items_cleaned.csv", "cart_items")

    with ENGINE.connect() as conn:
        print("\n--- Row Count Verification ---")
        for tbl in ["products", "users", "carts", "cart_items"]:
            count = conn.execute(text(f"SELECT COUNT(*) FROM {DB_SCHEMA}.{tbl};")).scalar_one()
            print(f"{DB_SCHEMA}.{tbl}: {count} rows")


if __name__ == "__main__":
    main()
