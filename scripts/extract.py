import json
import os
from pathlib import Path
from dotenv import load_dotenv
import pandas as pd
import requests

# Load API URLs from .env
load_dotenv()

endpoints = {
    "products": (
        os.getenv("PRODUCTS_API_URL", "https://dummyjson.com/products?limit=100"),
        "products",
        Path("data/raw/products_raw.json"),
    ),
    "users": (
        os.getenv("USERS_API_URL", "https://dummyjson.com/users?limit=100"),
        "users",
        Path("data/raw/users_raw.json"),
    ),
    "carts": (
        os.getenv("CARTS_API_URL", "https://dummyjson.com/carts?limit=100"),
        "carts",
        Path("data/raw/carts_raw.json"),
    ),
}

for label, (url, json_key, out_path) in endpoints.items():
    response = requests.get(url, timeout=15)
    response.raise_for_status()
    payload = response.json()

    out_path.parent.mkdir(parents=True, exist_ok=True)
    with open(out_path, "w", encoding="utf-8") as file:
        json.dump(payload, file, indent=2)

    df = pd.DataFrame(payload[json_key])
    print(f"[{label}] Saved {len(df)} rows to {out_path} | Columns: {list(df.columns)}")