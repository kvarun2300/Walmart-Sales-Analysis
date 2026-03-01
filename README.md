# Walmart-Sales-Analysis (Python + SQL + Power BI)
Tools used : GoogleColab, MySQL, PowerBI

1️.Explore the Data

Goal: Understand the raw dataset before transformation.

Actions:View sample records using .head().

Inspect column names, data types, and structure using .info().

Check statistical distribution using .describe().

Identify initial issues such as missing values, incorrect datatypes, outliers, and formatting inconsistencies.

2️.Data Cleaning

Actions:Remove Duplicates: Identify and drop duplicate rows to avoid skewed analysis.

Handle Missing Values:Drop rows/columns if missing data is insignificant.

Fill missing values where required.

Fix Data Types:Convert date columns to datetime.

Ensure numeric columns are stored as int or float.

Currency Formatting:Use .replace() and .astype(float) to clean currency-formatted fields.

Validation:Verify that no inconsistencies remain after cleaning.

3️.Feature Engineering

Actions:Create a Total Amount column:

total_amount = unit_price * quantity

Add newly engineered columns to improve SQL aggregation and analysis.

Prepare the dataset for loading into SQL.

4️.Load Data into MySQL

Actions: Create MySQL Tables: Define schema and create required tables.

Load Cleaned Data: Use SQLAlchemy, PyMySQL, or CSV import.

Verification:Run sample SQL queries to confirm accurate data loading.

Check row counts, datatypes, and sample records.

5️.SQL Analysis & Business Problem Solving


Actions:Write SQL queries to answer key business questions:

Revenue trends by branch and category.

Best-selling product categories.

Sales performance across time, city, and payment method.

Peak sales periods and customer buying patterns.

Profit margin analysis by branch and category.

6️.Data Visualization (Power BI Dashboard)

Actions:Create visual dashboards to represent business metrics and insights.

Include: KPIs: Total Sales, Profit, Transactions, Avg Rating.

Category-wise Sales (Bar/Donut charts)

Payment Method Usage (Pie chart)

Monthly Sales Trends (Line graph)

Top & Bottom Branches Analysis

Profitability Analysis

7️. Project Documentation & Publishing

Actions:Write complete documentation in:README.md,Google Colab

Include:Project overview,Steps followed (cleaning → SQL → visualization),Screenshots of dashboards,SQL scripts,Python notebook

Publish the full project on GitHub with structured folders:/notebooks /sql_queries /data /images /dashboard

8️.Results & Insights

Include key findings such as:

Sales Insights:Top-performing categories,Best and worst performing branches,Most preferred payment methods

Profitability Insights:Categories/branches with highest profit margins

Customer Behavior:Rating trends,Purchase patterns,Monthly trends
