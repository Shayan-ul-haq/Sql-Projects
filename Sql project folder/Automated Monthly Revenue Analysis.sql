/* =====================================================
   Report Name : Monthly Revenue Analysis
   Domain      : Web Sales
   Purpose     : Power BI automated revenue reporting
   ===================================================== */

WITH Monthly_Revenue AS (
    SELECT
        d.Year,
        d.Month,
        d.MonthName,
        SUM(s.OrderAmount) AS TotalRevenue,
        COUNT(DISTINCT s.OrderID) AS TotalOrders,
        AVG(s.OrderAmount) AS AvgOrderValue
    FROM WebSales s
    JOIN DateTable d ON s.OrderDate = d.DateID
    GROUP BY d.Year, d.Month, d.MonthName
)

SELECT
    Year,
    MonthName,
    TotalRevenue,
    TotalOrders,
    AvgOrderValue,
    LAG(TotalRevenue) OVER (ORDER BY Year, Month) AS PreviousMonthRevenue,
    TotalRevenue -
    LAG(TotalRevenue) OVER (ORDER BY Year, Month) AS RevenueGrowth
FROM Monthly_Revenue
ORDER BY Year, Month;
