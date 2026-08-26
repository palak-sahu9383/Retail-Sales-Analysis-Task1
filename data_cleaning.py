import pandas as pd

# Ek hi baar read karo
df = pd.read_excel("Retail_Raw_Dataset.xlsx")

print("Raw Shape:", df.shape)

# 1. Duplicate hatao
df = df.drop_duplicates()

# 2. Invalid Quantity aur Negative Sales hatao
df = df[df["Quantity"].isna() | (df["Quantity"] > 0)]
df = df[df["Sales"].isna() | (df["Sales"] >= 0)]

# 3. Product price se missing bharo - tera logic sahi tha
product_prices = {
    "P001": 65000, "P002": 1500, "P003": 4500, "P004": 32000,
    "P005": 18000, "P006": 8500, "P007": 12000, "P008": 7000,
    "P009": 3500, "P010": 2200, "P011": 1800, "P012": 5500,
    "P013": 7500, "P014": 1800, "P015": 4200
}
# Missing Sales
missing_sales = df["Sales"].isna()
df.loc[missing_sales, "Sales"] = df.loc[missing_sales, "ProductID"].map(product_prices) * df.loc[missing_sales, "Quantity"] * (1 - df.loc[missing_sales, "Discount"])

# Missing Quantity
missing_qty = df["Quantity"].isna()
df.loc[missing_qty, "Quantity"] = df.loc[missing_qty, "Sales"] / (df.loc[missing_qty, "ProductID"].map(product_prices) * (1 - df.loc[missing_qty, "Discount"]))

# 4. YE 4 LINE ADD KAR - jo miss thi
df["Region"] = df["Region"].str.strip().str.title() # central -> Central
df["PaymentMode"] = df["PaymentMode"].str.strip().str.title()
df["PaymentMode"] = df["PaymentMode"].replace({"Upi": "UPI"})
df["OrderStatus"] = df["OrderStatus"].str.strip().str.title() # completed -> Completed

# 5. Missing values ko sahi se bharo
df["CustomerID"] = df["CustomerID"].fillna("C0000") # Blank ko Walk-in
df["PaymentMode"] = df["PaymentMode"].fillna("Credit Card") # Unknown nahi
df["OrderDate"] = pd.to_datetime(df["OrderDate"], errors="coerce")
df = df.dropna(subset=["OrderDate"]) # Jiski date hi nahi usko hatao

# 6. CustomerName se number hatao
df["CustomerName"] = df["CustomerName"].str.replace(r'\s\d+', '', regex=True)

# 7. Profit Margin banao
df["Profit Margin"] = df["Profit"] / df["Sales"]

print("\nFinal Validation:")
print(df.shape)
print(df.isnull().sum())
print(df["PaymentMode"].value_counts())
print(df["Region"].value_counts())
print(df["OrderStatus"].value_counts())

df.to_excel("Retail_Cleaned_FINAL.xlsx", index=False)
print("Saved!")

  