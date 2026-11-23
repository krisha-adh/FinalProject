# E-Commerce Analytics & Business Intelligence (`FinalProject`)

## 1. Project Overview

This project is an end-to-end **E-Commerce Business Analytics and Business Intelligence** project developed as my final project. It uses data from the [DummyJSON API](https://dummyjson.com/) and combines Python, PostgreSQL, SQL, and Power BI to perform data extraction, cleaning, transformation, analysis, and visualization.

The project workflow includes:

- Extracting raw e-commerce data using Python and the DummyJSON API.
- Cleaning and transforming data using Pandas.
- Loading cleaned datasets into PostgreSQL.
- Performing SQL-based and Python-based data analysis.
- Building an interactive Power BI dashboard with DAX measures and calculated columns.
- Analyzing customer demographics, including age groups and gender.
- Creating visual reports and saving dashboard and DAX screenshots.

### Technologies and Tools

- **Python:** `requests`, `pandas`, `python-dotenv`
- **Database:** PostgreSQL
- **Database Management:** DBeaver
- **SQL Development:** VS Code
- **Data Visualization:** Microsoft Power BI
- **Data Modeling:** DAX
- **Version Control:** Git and GitHub Desktop
- **Dataset Source:** DummyJSON API

---

## 2. Project Folder Structure

`## 2. Project Folder Structure

```text
FinalProject/
│
├── README.md
│
├── data/
│   ├── cleaned/
│   │   ├── cart_items_cleaned.csv
│   │   ├── carts_cleaned.csv
│   │   ├── powerbi_dashboard_data.csv
│   │   ├── products_cleaned.csv
│   │   └── users_cleaned.csv
│   │
│   └── raw/
│       ├── carts_raw.json
│       ├── products_raw.json
│       └── users_raw.json
│
├── notebooks/
│   ├── analytics.ipynb
│   └── cleaning.ipynb
│
├── powerbi/
│   └── ecommerce_analytics_report.pbix
│
├── requirements.txt
│
├── screenshots/
│   ├── a.png
│   ├── b.png
│   ├── beaver.png
│   ├── c.png
│   ├── d.png
│   ├── e.png
│   ├── f.png
│   ├── g.png
│   ├── h.png
│   ├── 11.png
│   ├── 22.png
│   ├── 33.png
│   ├── 44.png
│   ├── 55.png
│   ├── 66.png
│   ├── 77.png
│   ├── 88.png
│   ├── 99.png
│   ├── 1010.png
│   ├── 1111.png
│   ├── 1212.png
│   ├── 1313.png
│   └── 1414.png
│
├── scripts/
│   ├── clean.py
│   ├── extract.py
│   └── load.py
│
└── sql/
    └── analysis.sql
```

## 3. Dataset Description

The project uses e-commerce data obtained from the DummyJSON API, covering products, customers, carts, and individual cart items.

### Raw Datasets

| File | Description |
|---|---|
| `carts_raw.json` | Raw cart and order data extracted from DummyJSON. |
| `products_raw.json` | Raw product catalog containing product information. |
| `users_raw.json` | Raw customer and user information. |

### Cleaned Datasets

| File | Description |
|---|---|
| `products_cleaned.csv` | Cleaned product data containing categories, brands, and prices. |
| `users_cleaned.csv` | Cleaned customer data used for demographic and age analysis. |
| `carts_cleaned.csv` | Cleaned cart data containing order totals and discounted totals. |
| `cart_items_cleaned.csv` | Cleaned order line-item data containing product quantities, discount percentages, and totals. |
| `powerbi_dashboard_data.csv` | Combined dataset prepared for Power BI visualizations and DAX calculations. |

---

## 4. Technologies Used

### Python

Python was used for data extraction, cleaning, transformation, loading, and exploratory analysis.

Libraries used:

- `requests` – Fetching data from the DummyJSON API.
- `pandas` – Data cleaning, transformation, and analysis.
- `python-dotenv` – Managing environment variables.

Python scripts:

- `scripts/extract.py`
- `scripts/clean.py`
- `scripts/load.py`

Jupyter notebooks:

- `notebooks/cleaning.ipynb`
- `notebooks/analytics.ipynb`

### PostgreSQL, DBeaver & VS Code

PostgreSQL was used to store the cleaned datasets and perform database-level analysis.

DBeaver was used for database management, schema creation, table management, and executing SQL queries.
![Dbeaver](screenshots/beaver.png)

VS Code was used to write and organize SQL queries in:

`sql/analysis.sql`

### Power BI & DAX

Microsoft Power BI was used to develop an interactive e-commerce analytics dashboard.

The dashboard includes:

- KPI Cards
- Order Line Details Table
- Bar Chart
- Pie Charts
- Column Chart
- Customer Demographic Analysis
- Gender-Based Revenue Analysis
- Category Slicer
- Drill-Down Functionality
- Interactive Tooltips
- Conditional Formatting
- Bookmarks
- DAX Measures
- DAX Calculated Columns

### Git & GitHub Desktop

Git and GitHub Desktop were used for version control, managing commits, maintaining the `.gitignore` file, and uploading the project repository to GitHub.

---

## 5. Installation and Setup

### Step 1: Clone the Repository

```bash
git clone <your-github-repo-url>
cd FinalProject
```

### Step 2: Create a Virtual Environment

```bash
python3 -m venv .venv
```

### Step 3: Activate the Virtual Environment

For macOS and Linux:

```bash
source .venv/bin/activate
```

For Windows:

```bash
.venv\Scripts\activate
```

### Step 4: Install Dependencies

```bash
pip install -r requirements.txt
```

### Step 5: Configure Environment Variables

Create a `.env` file in the project root directory and add the required environment variables for your PostgreSQL database connection.

The `.env` file is excluded from Git tracking through `.gitignore` to protect sensitive configuration information.

### Step 6: Run the Project

Execute the Python scripts in the following order:

```bash
python scripts/extract.py
python scripts/clean.py
python scripts/load.py
```

Alternatively, open the Jupyter notebooks:

- `notebooks/cleaning.ipynb`
- `notebooks/analytics.ipynb`

Create the required PostgreSQL schema and tables using DBeaver, then execute the SQL queries from:

`sql/analysis.sql`

### Step 7: Open the Power BI Dashboard

Open the following file using Power BI Desktop:

`powerbi/ecommerce_analytics_report.pbix`

The dashboard screenshots are also available in the `screenshots/` directory.

---

## 6. API Used

### DummyJSON API

[DummyJSON](https://dummyjson.com/) was used as a mock e-commerce data source instead of a paid external API.

It provided sample data for:

- Products
- Carts
- Users
- Order and cart items

The API was used to simulate an e-commerce dataset for business intelligence and analytical purposes.

---

## 7. DAX Calculations Used

The Power BI dashboard includes multiple DAX measures and calculated columns to perform business calculations, categorize records, and support interactive reporting.

## 7. DAX Calculations screenshots
![DAX Calculations](screenshots/11.png)
![DAX Calculations](screenshots/22.png)
![DAX Calculations](screenshots/33.png)
![DAX Calculations](screenshots/44.png)
![DAX Calculations](screenshots/55.png)
![DAX Calculations](screenshots/66.png)
![DAX Calculations](screenshots/77.png)
![DAX Calculations](screenshots/88.png)
![DAX Calculations](screenshots/99.png)
![DAX Calculations](screenshots/1010.png)
![DAX Calculations](screenshots/1111.png)
![DAX Calculations](screenshots/1212.png)
![DAX Calculations](screenshots/1313.png)
![DAX Calculations](screenshots/1414.png)

### 7.1 DAX Measures

**1. Total Records (COUNTROWS)**

```dax
Total Records = COUNTROWS(powerbi_dashboard_data)
```

**2. Total Users (DISTINCTCOUNT)**

Counts unique customers using their user IDs.

```dax
Total Users =
DISTINCTCOUNT(powerbi_dashboard_data[user_id])
```

**3. Total Line Items (COUNTROWS)**

Counts the total number of order-line records in the combined Power BI dataset.

```dax
Total Line Items =
COUNTROWS(powerbi_dashboard_data)
```

**4. Average Discounted Total (AVERAGEX)**

```dax
Avg Discounted Total =
AVERAGEX(
    powerbi_dashboard_data,
    powerbi_dashboard_data[discounted_total]
)
```

**5. Minimum Net Revenue (MIN)**

```dax
Min Discounted Total =
MIN(powerbi_dashboard_data[discounted_total])
```

**6. Maximum Net Revenue (MAX)**

```dax
Max Discounted Total =
MAX(powerbi_dashboard_data[discounted_total])
```

**7. Gross Line Sum (SUMX)**

```dax
Gross Line SumX =
SUMX(
    powerbi_dashboard_data,
    powerbi_dashboard_data[quantity] *
    powerbi_dashboard_data[total]
)
```

**8. Distinct Categories (DISTINCTCOUNT)**

```dax
Distinct Categories =
DISTINCTCOUNT(powerbi_dashboard_data[category])
```

**9. Beauty Net Revenue (CALCULATE)**

```dax
Beauty Net Revenue =
CALCULATE(
    SUM(powerbi_dashboard_data[discounted_total]),
    powerbi_dashboard_data[category] = "beauty"
)
```

### 7.2 Calculated Columns

**1. Order Year (YEAR)**

```dax
Order Year =
YEAR(powerbi_dashboard_data[created_at])
```

**2. Calculated Age Group (DATEDIFF, TODAY, IF)**

Customers are grouped into four age categories, with an additional Unknown category for missing birth dates.

```dax
Calculated Age Group =
VAR CurrentAge =
    DATEDIFF(
        powerbi_dashboard_data[birth_date],
        TODAY(),
        YEAR
    )
RETURN
IF(
    ISBLANK(powerbi_dashboard_data[birth_date]),
    "Unknown",
    IF(
        CurrentAge < 25,
        "Under 25",
        IF(
            CurrentAge <= 34,
            "25-34",
            IF(CurrentAge <= 49, "35-49", "50+")
        )
    )
)
```

**3. Category Tier (SWITCH)**

```dax
Category Tier =
SWITCH(
    TRUE(),
    powerbi_dashboard_data[category] = "beauty", "Personal Care",
    powerbi_dashboard_data[category] = "fragrances", "Personal Care",
    powerbi_dashboard_data[category] = "groceries", "Essentials",
    powerbi_dashboard_data[category] = "furniture", "Home & Living",
    powerbi_dashboard_data[category] = "home-decoration", "Home & Living",
    "Other"
)
```

**4. Has Pro Keyword (FIND, IF)**

```dax
Has Pro Keyword =
IF(
    IFERROR(
        FIND("Pro", powerbi_dashboard_data[title], 1, 0),
        0
    ) > 0,
    "Contains Pro",
    "Standard"
)
```

**5. Discount Status (IF)**

```dax
Discount Status =
IF(
    powerbi_dashboard_data[discounted_total] <
    powerbi_dashboard_data[total],
    "Discounted",
    "Full Price"
)
```

**6. Customer Age Years (DATEDIFF, TODAY)**

```dax
Customer Age Years =
DATEDIFF(
    powerbi_dashboard_data[birth_date],
    TODAY(),
    YEAR
)
```

---

## 8. Power BI Dashboard & Screenshots

![power bi dashboard](screenshots/a.png)
![power bi dashboard](screenshots/b.png)
![power bi dashboard](screenshots/c.png)
![power bi dashboard](screenshots/d.png)
![power bi dashboard](screenshots/e.png)
![power bi dashboard](screenshots/f.png)
![power bi dashboard](screenshots/g.png)
![power bi dashboard](screenshots/h.png)


### 8.1 Dashboard Components

The interactive Power BI dashboard contains the following elements:

**1. KPI Cards**

The left section of the dashboard displays five key performance indicators:

| KPI | Displayed Value |
|---|---:|
| Total Users | 100 |
| Gross Revenue | 2.19M |
| Total Quantity | 1K |
| Total Line Items | 376 |
| Net Revenue | 1.97M |

These KPIs provide an overview of customer volume, sales performance, order activity, and discounted revenue.

**2. Order Line Details Table**

The top-center section contains an order line details table with conditional formatting.

- Displays product titles, categories, brands, quantities, and discounted totals.
- Uses pink and purple shading to highlight the `Sum of discounted_total` column.
- Includes a total row showing:
  - Total Quantity: 1,129
  - Net Revenue: Approximately 1.97M

**3. Revenue Share by Age Group (Pie Chart)**

The top-right section displays revenue distribution across customer age groups.

| Age Group | Net Revenue | Revenue Share |
|---|---:|---:|
| 25–34 | 1.5M | 76.06% |
| 35–49 | 0.43M | 21.57% |
| Under 25 | 0.05M | 2.37% |

The `Calculated Age Group` column also includes the 50+ category and Unknown for missing birth dates.

**4. Revenue by Gender (Pie Chart)**

The dashboard includes an additional pie chart showing the distribution of discounted revenue by customer gender.

| Gender | Net Revenue | Revenue Share |
|---|---:|---:|
| Female | 0.81M | 41.15% |
| Male | 1.16M | 58.85% |

This visualization helps compare revenue contributions across customer genders.

**5. Category Slicer**

An interactive slicer is positioned in the upper-right section of the dashboard.

It allows users to filter the dashboard based on product categories and explore the performance of individual categories.

**6. Revenue Drill-Down (Column Chart)**

The bottom-center section contains a drill-down visualization following this hierarchy:

`Category → Brand → Product`

This allows users to explore revenue performance at different levels of product detail.

**7. Net Revenue by Category (Bar Chart)**

The bottom-right section displays a horizontal bar chart comparing net revenue across product categories.

It helps identify high-performing categories and compare their contribution to overall revenue.

**8. Tooltips and Bookmarks**

- Interactive tooltips provide additional information when hovering over dashboard visuals.
- Bookmarks save specific report views and allow users to navigate between predefined dashboard states.

### 8.2 Dashboard Screenshots

Dashboard views and DAX calculation screenshots are available in the `screenshots/` directory.

---

## 9. Business Insights & Findings

### 9.1 What Trends Can Be Observed from the Data?

- Gross revenue is approximately 2.19M, while net revenue is approximately 1.97M.
- This indicates that discounts reduce the overall revenue generated from orders.
- The 25–34 age group contributes the largest share of revenue, accounting for 76.06% of the total.
- The male customer segment contributes approximately 58.85% of net revenue, compared to 41.15% from the female customer segment.
- Revenue is concentrated in a few high-performing product categories and products.
- Customer demographic analysis provides additional insight into how different age groups and genders contribute to overall sales.

### 9.2 Which Categories or Entities Perform the Best?

- The 25–34 customer age group generates the highest revenue, contributing approximately 1.5M (76.06%).
- Male customers contribute approximately 1.16M (58.85%) in discounted revenue.
- Men's watches are among the strongest-performing categorized product categories.
- Other strong-performing categories include:
  - Laptops
  - Furniture
  - Men's shoes
  - Fragrances
- Products such as Watch Gold for Women and Vivo X21 also show high totals in the order line details table.
- Uncategorized products also contribute significantly to revenue and sales quantity, making them important to the overall business analysis.

### 9.3 Are There Any Unusual Patterns or Outliers?

- Approximately 27–28 items have blank or uncategorized product categories, even when their product names suggest identifiable categories such as dresses, phones, and accessories.
- These uncategorized products have been intentionally retained in the dataset and dashboard rather than removed. They include high-value products that have also been selling in good quantities.
- Removing these records could lead to the loss of important sales and revenue information and would potentially underrepresent overall business performance.
- There is a significant difference between high-value products, such as Watch Gold for Women and Vivo X21, and lower-cost products, such as Water and Tissue Paper Box.
- The dashboard displays 376 total line items and 100 distinct users.
- The KPI card displays approximately 1K total quantity, while the order line table shows an exact total quantity of 1,129. The difference is due to the KPI card's abbreviated number formatting.
- Net revenue is approximately 1.97M, consistent with the order line table's aggregated discounted totals.

### 9.4 What KPIs Are Most Important?

The following KPIs are particularly important for monitoring e-commerce business performance:

1. Total Users
2. Gross Revenue
3. Net Revenue (Sum of `discounted_total`)
4. Total Quantity Sold
5. Total Line Items
6. Revenue Share by Customer Age Group
7. Revenue Distribution by Gender
8. Net Revenue by Product Category
9. Category, Brand, and Product Revenue Drill-Down

### 9.5 Recommendations to Management

Based on the analysis, the following recommendations can be made:

**1. Maintain and Improve Product Category Mapping**

Investigate the approximately 27–28 uncategorized product records to understand why their category information is missing.

These records should not be removed simply because their categories are blank. They have demonstrated significant revenue contribution and sales quantities. Instead, management should retain these records and consider assigning appropriate categories after validating the product information.

**2. Focus on the Highest-Revenue Customer Segment**

The 25–34 age group contributes approximately 76.06% of total revenue. Management should consider targeted marketing campaigns, personalized recommendations, and customer retention strategies for this segment.

**3. Develop Gender-Based Marketing Strategies**

Male customers contribute approximately 58.85% of net revenue, while female customers contribute approximately 41.15%.

Management could explore gender-based purchasing preferences and product interests to develop more relevant marketing campaigns, while continuing to target both customer segments.

**4. Explore Growth Opportunities in Other Age Groups**

The 35–49 age group contributes approximately 21.57% of revenue, while customers under 25 contribute approximately 2.37%.

Management could experiment with targeted offers and marketing campaigns to increase engagement and revenue from these segments.

**5. Monitor Product Discounts**

Analyze discounts applied to both high-value and low-value products to ensure that promotional strategies support sales growth without unnecessarily reducing profitability.

**6. Prioritize High-Performing Product Categories and Products**

Consider inventory planning and marketing strategies for strong-performing categories such as men's watches, laptops, furniture, men's shoes, and fragrances.

High-value uncategorized products should also be considered when making inventory and sales decisions.

**7. Improve Data Consistency and KPI Validation**

Continue reviewing aggregation methods, filters, relationships, and DAX calculations to ensure that KPI cards, tables, and charts provide consistent results across the dashboard.

---

## 10. Project Outcome

This project demonstrates an end-to-end data analytics and business intelligence workflow, starting from raw API data extraction and ending with an interactive Power BI dashboard.

Through this project, I gained practical experience in:

- Working with REST APIs and JSON datasets.
- Data cleaning and transformation using Python and Pandas.
- Relational database management using PostgreSQL.
- Writing and executing SQL queries.
- Performing exploratory data analysis.
- Creating DAX measures and calculated columns.
- Analyzing customer demographics through age and gender segmentation.
- Designing interactive Power BI dashboards.
- Interpreting business data and generating actionable insights.
- Managing project files and version control using Git and GitHub.

The final outcome is an interactive e-commerce analytics report that transforms raw e-commerce data into meaningful business insights to support data-driven decision-making.

---

## 11. Project Files

| Resource | Location |
|---|---|
| Data Extraction Script | `scripts/extract.py` |
| Data Cleaning Script | `scripts/clean.py` |
| Database Loading Script | `scripts/load.py` |
| Data Cleaning Notebook | `notebooks/cleaning.ipynb` |
| Analytics Notebook | `notebooks/analytics.ipynb` |
| SQL Analysis | `sql/analysis.sql` |
| Power BI Dashboard | `powerbi/ecommerce_analytics_report.pbix` |
| Screenshots | `screenshots/` |

---

**Project:** E-Commerce Analytics 
**Dataset Source:** [DummyJSON](https://dummyjson.com/)  
**Tools:** Python, Pandas, PostgreSQL, SQL, DBeaver, Power BI, DAX, Git & GitHub
**Submitted By** Krisha Adhikari