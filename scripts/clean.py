import json
from pathlib import Path
import pandas as pd

raw_dir = Path("data/raw")
cleaned_dir = Path("data/cleaned")
cleaned_dir.mkdir(parents=True, exist_ok=True)

with open(raw_dir / "products_raw.json", "r", encoding="utf-8") as f:
    products_raw = json.load(f)["products"]

with open(raw_dir / "users_raw.json", "r", encoding="utf-8") as f:
    users_raw = json.load(f)["users"]

with open(raw_dir / "carts_raw.json", "r", encoding="utf-8") as f:
    carts_raw = json.load(f)["carts"]

products_df = pd.DataFrame(products_raw)
users_df = pd.DataFrame(users_raw)
carts_df = pd.DataFrame(carts_raw)

# Cleaning Step 1: Remove duplicate rows by primary ID across tables
products_df = products_df.drop_duplicates(subset=["id"]).copy()
users_df = users_df.drop_duplicates(subset=["id"]).copy()
carts_df = carts_df.drop_duplicates(subset=["id"]).copy()

# Cleaning Step 2: Handle missing values (fill missing brand and middle/maiden names safely)
products_df["brand"] = products_df["brand"].fillna("Unbranded")
users_df["maidenName"] = users_df["maidenName"].fillna("")

# Cleaning Step 3: Rename columns to clean snake_case
products_df = products_df.rename(
    columns={
        "discountPercentage": "discount_percentage",
        "warrantyInformation": "warranty_info",
        "shippingInformation": "shipping_info",
        "availabilityStatus": "availability_status",
        "returnPolicy": "return_policy",
        "minimumOrderQuantity": "min_order_qty",
    }
)

users_df = users_df.rename(
    columns={
        "firstName": "first_name",
        "lastName": "last_name",
        "maidenName": "maiden_name",
        "birthDate": "birth_date",
        "bloodGroup": "blood_group",
        "eyeColor": "eye_color",
    }
)

carts_df = carts_df.rename(
    columns={
        "userId": "user_id",
        "discountedTotal": "discounted_total",
        "totalProducts": "total_products",
        "totalQuantity": "total_quantity",
    }
)

# Cleaning Step 4: Convert numeric and integer columns cleanly
for col in ["price", "discount_percentage", "rating", "weight"]:
    products_df[col] = pd.to_numeric(products_df[col], errors="coerce")

for col in ["stock", "min_order_qty"]:
    products_df[col] = pd.to_numeric(products_df[col], errors="coerce").fillna(0).astype(int)

for col in ["age", "height", "weight"]:
    users_df[col] = pd.to_numeric(users_df[col], errors="coerce")

for col in ["total", "discounted_total"]:
    carts_df[col] = pd.to_numeric(carts_df[col], errors="coerce")

for col in ["total_products", "total_quantity"]:
    carts_df[col] = pd.to_numeric(carts_df[col], errors="coerce").fillna(0).astype(int)

# Cleaning Step 5: Parse date columns with pd.to_datetime
users_df["birth_date"] = pd.to_datetime(users_df["birth_date"], errors="coerce")
products_df["created_at"] = pd.to_datetime(
    products_df["meta"].apply(lambda m: m.get("createdAt") if isinstance(m, dict) else None),
    errors="coerce",
)

# Cleaning Step 6: Extract nested dictionary/list fields (city/country from address, tag count)
users_df["city"] = users_df["address"].apply(
    lambda a: a.get("city") if isinstance(a, dict) else None
)
users_df["country"] = users_df["address"].apply(
    lambda a: a.get("country") if isinstance(a, dict) else None
)
products_df["tag_count"] = products_df["tags"].apply(
    lambda t: len(t) if isinstance(t, list) else 0
)

# Cleaning Step 7: Split text into separate columns (full name, shipping summary)
users_df["full_name"] = (
    users_df["first_name"].astype(str).str.strip() + " " + users_df["last_name"].astype(str).str.strip()
).str.strip()
products_df["shipping_summary"] = (
    products_df["shipping_info"].astype(str).str.split("-").str[0].str.strip()
)

# Cleaning Step 8: Standardize text casing and strip extra whitespace
products_df["category"] = (
    products_df["category"].astype(str).str.strip().str.lower().str.replace("-", " ", regex=False)
)
products_df["brand"] = products_df["brand"].astype(str).str.strip()
products_df["availability_status"] = (
    products_df["availability_status"].astype(str).str.strip().str.title()
)
users_df["gender"] = users_df["gender"].astype(str).str.strip().str.lower()
users_df["email"] = users_df["email"].astype(str).str.strip().str.lower()

# Cleaning Step 9: Create calculated columns for business analysis
products_df["discounted_price"] = (
    products_df["price"] * (1 - products_df["discount_percentage"] / 100)
).round(2)
products_df["stock_value"] = (products_df["discounted_price"] * products_df["stock"]).round(2)
carts_df["cart_savings"] = (carts_df["total"] - carts_df["discounted_total"]).round(2)
carts_df["avg_item_value"] = (
    carts_df["discounted_total"] / carts_df["total_quantity"].replace(0, pd.NA)
).round(2)

# Unpack cart line items before dropping 'products' from carts_df
cart_items_rows = []
for _, row in carts_df.iterrows():
    items = row.get("products")
    if isinstance(items, list):
        for item in items:
            if isinstance(item, dict):
                cart_items_rows.append(
                    {
                        "cart_id": row["id"],
                        "user_id": row["user_id"],
                        "product_id": item.get("id"),
                        "title": item.get("title"),
                        "price": item.get("price"),
                        "quantity": item.get("quantity"),
                        "total": item.get("total"),
                        "discount_percentage": item.get("discountPercentage"),
                        "discounted_total": item.get("discountedTotal"),
                    }
                )

cart_items_df = pd.DataFrame(cart_items_rows)
if not cart_items_df.empty:
    cart_items_df = cart_items_df.drop_duplicates().copy()
    for col in ["price", "total", "discount_percentage", "discounted_total"]:
        cart_items_df[col] = pd.to_numeric(cart_items_df[col], errors="coerce")
    cart_items_df["quantity"] = pd.to_numeric(cart_items_df["quantity"], errors="coerce").fillna(0).astype(int)

# Cleaning Step 10: Drop noisy/sensitive/nested columns not needed in flat tables
product_drops = ["thumbnail", "images", "meta", "reviews", "dimensions", "tags", "shipping_info"]
user_drops = ["password", "ssn", "ein", "ip", "macAddress", "userAgent", "address", "hair", "bank", "company", "crypto", "image"]
cart_drops = ["products"]

products_df = products_df.drop(columns=[c for c in product_drops if c in products_df.columns])
users_df = users_df.drop(columns=[c for c in user_drops if c in users_df.columns])
carts_df = carts_df.drop(columns=[c for c in cart_drops if c in carts_df.columns])

# Save cleaned CSVs to data/cleaned/
products_df.to_csv(cleaned_dir / "products_cleaned.csv", index=False)
users_df.to_csv(cleaned_dir / "users_cleaned.csv", index=False)
carts_df.to_csv(cleaned_dir / "carts_cleaned.csv", index=False)
cart_items_df.to_csv(cleaned_dir / "cart_items_cleaned.csv", index=False)

print("Saved cleaned files to data/cleaned/:")
print(f" - products_cleaned.csv: {len(products_df)} rows, {len(products_df.columns)} cols")
print(f" - users_cleaned.csv:    {len(users_df)} rows, {len(users_df.columns)} cols")
print(f" - carts_cleaned.csv:    {len(carts_df)} rows, {len(carts_df.columns)} cols")
print(f" - cart_items_cleaned.csv: {len(cart_items_df)} rows, {len(cart_items_df.columns)} cols")