-- ==============================================================================
-- Project: E-Commerce Sales Performance & Profitability Analysis
-- Author: Subham Nath (github.com/subham18nath)
-- Database Engine: PostgreSQL / MySQL / SQL Server compatible
-- ==============================================================================

-- 1. OVERALL BUSINESS KPIS
SELECT 
    COUNT(DISTINCT o.OrderID) AS total_orders,
    COUNT(DISTINCT o.CustomerID) AS total_customers,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)), 2) AS total_net_revenue,
    ROUND(SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)), 2) AS total_net_profit,
    ROUND(
        (SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)) / 
         SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct))) * 100, 2
    ) AS overall_profit_margin_pct,
    ROUND(
        SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)) / COUNT(DISTINCT o.OrderID), 2
    ) AS average_order_value
FROM orders o
JOIN order_items oi ON o.OrderID = oi.OrderID
WHERE o.OrderStatus = 'Delivered';

-- 2. MONTHLY REVENUE & PROFIT MARGIN TRENDS (MoM Growth)
WITH monthly_metrics AS (
    SELECT 
        DATE_TRUNC('month', o.OrderDate::date) AS sales_month,
        ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)), 2) AS net_revenue,
        ROUND(SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)), 2) AS net_profit
    FROM orders o
    JOIN order_items oi ON o.OrderID = oi.OrderID
    WHERE o.OrderStatus = 'Delivered'
    GROUP BY 1
)
SELECT 
    TO_CHAR(sales_month, 'YYYY-MM') AS month_label,
    net_revenue,
    net_profit,
    ROUND((net_profit / net_revenue) * 100, 2) AS profit_margin_pct,
    ROUND(
        ((net_revenue - LAG(net_revenue) OVER (ORDER BY sales_month)) / 
         NULLIF(LAG(net_revenue) OVER (ORDER BY sales_month), 0)) * 100, 2
    ) AS mom_revenue_growth_pct
FROM monthly_metrics
ORDER BY sales_month;

-- 3. TOP 5 BEST-SELLING PRODUCTS BY NET REVENUE & PROFIT MARGIN
SELECT 
    p.ProductID,
    p.ProductName,
    p.Category,
    SUM(oi.Quantity) AS units_sold,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)), 2) AS total_net_revenue,
    ROUND(SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)), 2) AS total_profit,
    ROUND(
        (SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)) / 
         SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct))) * 100, 2
    ) AS profit_margin_pct,
    DENSE_RANK() OVER (ORDER BY SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)) DESC) AS revenue_rank
FROM order_items oi
JOIN products p ON oi.ProductID = p.ProductID
JOIN orders o ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.ProductID, p.ProductName, p.Category
ORDER BY total_net_revenue DESC
LIMIT 5;

-- 4. CATEGORY CONTRIBUTION & MARGIN EFFICIENCY
SELECT 
    p.Category,
    COUNT(DISTINCT o.OrderID) AS total_orders,
    ROUND(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)), 2) AS net_revenue,
    ROUND(SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)), 2) AS net_profit,
    ROUND(
        (SUM(oi.Quantity * (oi.UnitPrice * (1 - oi.DiscountPct) - oi.UnitCost)) / 
         SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct))) * 100, 2
    ) AS profit_margin_pct,
    ROUND(
        (SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct)) / 
         SUM(SUM(oi.Quantity * oi.UnitPrice * (1 - oi.DiscountPct))) OVER ()) * 100, 2
    ) AS revenue_share_pct
FROM order_items oi
JOIN products p ON oi.ProductID = p.ProductID
JOIN orders o ON oi.OrderID = o.OrderID
WHERE o.OrderStatus = 'Delivered'
GROUP BY p.Category
ORDER BY net_revenue DESC;
