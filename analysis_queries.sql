-- ============================================
-- Superstore Sales Analysis — SQL Queries
-- ============================================

-- 1) Top 10 products by profit
SELECT [Product Name], Profit 
FROM orders
ORDER BY Profit DESC
LIMIT 10;


-- 2) Total sales and profit per category
SELECT Category, 
       SUM(Sales) AS TotalSales, 
       SUM(Profit) AS TotalProfit
FROM orders
GROUP BY Category
ORDER BY TotalProfit DESC;


-- 3) Monthly sales trend
SELECT 
    substr([Order Date], -4) || '-' || 
    CASE WHEN length(substr([Order Date], 1, instr([Order Date], '/')-1)) = 1 
         THEN '0' || substr([Order Date], 1, instr([Order Date], '/')-1)
         ELSE substr([Order Date], 1, instr([Order Date], '/')-1) 
    END AS OrderMonth,
    SUM(Sales) AS MonthlySales
FROM orders
GROUP BY OrderMonth
ORDER BY OrderMonth;


-- 4) Month-over-month sales growth (using LAG window function)
SELECT 
    OrderMonth,
    MonthlySales,
    LAG(MonthlySales) OVER (ORDER BY OrderMonth) AS PreviousMonthSales,
    ROUND(
        (MonthlySales - LAG(MonthlySales) OVER (ORDER BY OrderMonth)) * 100.0 
        / LAG(MonthlySales) OVER (ORDER BY OrderMonth), 
    2) AS GrowthPercent
FROM (
    SELECT 
        substr([Order Date], -4) || '-' || 
        CASE WHEN length(substr([Order Date], 1, instr([Order Date], '/')-1)) = 1 
             THEN '0' || substr([Order Date], 1, instr([Order Date], '/')-1)
             ELSE substr([Order Date], 1, instr([Order Date], '/')-1) 
        END AS OrderMonth,
        SUM(Sales) AS MonthlySales
    FROM orders
    GROUP BY OrderMonth
)
ORDER BY OrderMonth;
