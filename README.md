 📌 Executive Summary
An end-to-end data analytics and business intelligence project analyzing **1,000+ e-commerce transactions** across **8 major Indian metro cities** in FY 2024. Using **SQL**, **Excel**, and **Power BI**, this solution transforms raw normalized order tables into actionable executive insights—evaluating **net revenue, profit margins, SKU-level profitability, discount erosion, and regional demand**.

### 🎯 Key Business Objectives
* **Revenue & Margin Integrity:** Isolate realized net revenue and net profit by filtering out cancelled and returned orders.
* **Product & Category Mix:** Contrast high-volume revenue drivers against high-margin product categories to optimize inventory and cross-selling.
* **Temporal & Seasonality Trends:** Track Month-over-Month (MoM) revenue growth, order volume, and Average Order Value (AOV).
* **Discount Sensitivity & Regional Reach:** Identify margin compression caused by aggressive discounting and pinpoint regional growth opportunities across India.

---

## 📊 Key Analytical Findings (Delivered Orders)

### 1. High-Level KPI Snapshot
| Metric | Performance | Business Context |
| :--- | :--- | :--- |
| **Total Net Revenue** | **₹31,04,292.55** | Realized revenue across 927 delivered orders |
| **Total Net Profit** | **₹15,16,852.55** | Bottom-line profit after COGS & line-item discounts |
| **Overall Profit Margin** | **48.86%** | Strong blended margin across all 4 product categories |
| **Average Order Value (AOV)** | **₹3,348.75** | Driven by multi-item baskets and high-ticket electronics |
| **Order Fulfillment Rate** | **92.70%** | 927 delivered vs. 73 cancelled/returned orders |

---

### 2. Category Performance & Margin Efficiency
| Category | Orders | Net Revenue (₹) | Revenue Share | Net Profit (₹) | Profit Margin |
| :--- | :---: | :---: | :---: | :---: | :---: |
| **Electronics** | 342 | ₹11,60,012.55 | 37.37% | ₹4,99,992.55 | 43.10% |
| **Home & Kitchen** | 340 | ₹8,60,882.45 | 27.73% | ₹3,98,252.45 | 46.26% |
| **Apparel** | 356 | ₹8,21,492.50 | 26.46% | ₹4,47,992.50 | 54.53% |
| **Beauty & Personal Care** | 333 | ₹2,61,905.05 | 8.44% | ₹1,70,615.05 | **65.14%** |

> 💡 **Strategic Takeaway:** While **Electronics** generates the largest top-line share (**37.37%**), **Beauty & Personal Care** yields the highest unit profitability (**65.14% margin**), and **Apparel** outperforms Home & Kitchen in net profit (₹4.48L vs. ₹3.98L) despite lower gross revenue.

---

### 3. Top 5 Best-Selling Products (by Net Revenue)
| Rank | Product Name | Category | Units Sold | Net Revenue (₹) | Net Profit (₹) | Margin % |
| :---: | :--- | :--- | :---: | :---: | :---: | :---: |
| **1** | **Smart Watch** | Electronics | 109 | ₹5,26,394.70 | ₹2,21,194.70 | 42.02% |
| **2** | **Air Fryer 4L** | Home & Kitchen | 115 | ₹5,09,799.15 | ₹2,10,799.15 | 41.35% |
| **3** | **Bluetooth Speaker** | Electronics | 153 | ₹2,92,553.65 | ₹1,24,253.65 | 42.47% |
| **4** | **Running Sneakers** | Apparel | 101 | ₹2,90,753.05 | ₹1,54,403.05 | **53.10%** |
| **5** | **Wireless Earbuds** | Electronics | 109 | ₹2,59,646.10 | ₹1,07,046.10 | 41.23% |

---

### 4. Regional Performance Breakdown
* **South India (Bengaluru, Chennai, Hyderabad):** Market leader generating **₹12,64,781.55** (**40.74%** revenue share) across 392 orders.
* **West India (Mumbai, Pune):** Second largest contributor at **₹7,99,644.60** (**25.76%** share).
* **North India (Delhi NCR, Jaipur):** Accounts for **₹7,34,591.45** (**23.66%** share).
* **East India (Kolkata):** Contributes **₹3,05,274.95** (**9.83%** share), representing an untapped growth market.

---

## 🛠️ Tech Stack & Data Architecture

```mermaid
flowchart LR
    A[Normalized CSVs / Database] --> B[SQL Querying & KPIs]
    B --> C[Excel Margin & What-If Modeling]
    C --> D[Power BI Star Schema & DAX]
    D --> E[Executive Decision Dashboard]
```

### Relational Star Schema
* **Fact Tables (`orders`, `order_items`):** Captures order timestamps, fulfillment status (`Delivered`, `Returned`, `Cancelled`), payment modes (`UPI`, `Credit Card`, `Debit Card`, `Net Banking`, `COD`), quantities, unit prices, costs, and discount rates.
* **Dimension Tables (`products`, `customers`):** Enriches transactions with SKU hierarchies, cost structures, and geographic attributes (`City`, `State`, `Region`).

---

## 💻 SQL & Power BI Implementation

### Featured SQL Analysis (`ecommerce_analysis.sql`)
* **Window Functions:** Leveraged `LAG()` over monthly aggregations for Month-over-Month (MoM) growth tracking and `DENSE_RANK()` for SKU ranking.
* **Profitability Logic:** Computed net realized margins after line-level discount deductions (`UnitPrice * (1 - DiscountPct) - UnitCost`).

### Core Power BI DAX Measures
```dax
Total Net Revenue = 
CALCULATE(
    SUM(ecommerce_sales_clean[NetRevenue]),
    ecommerce_sales_clean[OrderStatus] = "Delivered"
)

Total Net Profit = 
CALCULATE(
    SUM(ecommerce_sales_clean[NetProfit]),
    ecommerce_sales_clean[OrderStatus] = "Delivered"
)

Profit Margin % = 
DIVIDE([Total Net Profit], [Total Net Revenue], 0)

Average Order Value = 
DIVIDE(
    [Total Net Revenue],
    CALCULATE(
        DISTINCTCOUNT(ecommerce_sales_clean[OrderID]),
        ecommerce_sales_clean[OrderStatus] = "Delivered"
    ),
    0
)

MoM Revenue Growth % = 
VAR CurrentMonthRev = [Total Net Revenue]
VAR PrevMonthRev = CALCULATE([Total Net Revenue], DATEADD('Date'[Date], -1, MONTH))
RETURN
DIVIDE(CurrentMonthRev - PrevMonthRev, PrevMonthRev, 0)
```

---

## 🚀 Actionable Business Recommendations
1. **High-Margin Cross-Sell Bundling:** Pair **Beauty & Personal Care** SKUs (65.14% margin) and **USB-C Fast Chargers** (~58% margin) as checkout add-ons for high-ticket Electronics buyers to boost blended order margins.
2. **Discount Guardrails on Hardware:** Cap promotional discounts on **Smart Watches** and **Air Fryers** at **10%**, as 15% discounts compress net profit margins down to ~33–34%.
3. **Regional Expansion in East & North:** Deploy targeted UPI cashback promotions in Kolkata and Jaipur to lift customer acquisition and repeat purchase frequency.
