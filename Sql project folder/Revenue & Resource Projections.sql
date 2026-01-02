/* =====================================================
   Report Name : Revenue & Resource Projections
   ===================================================== */

WITH Historical_Performance AS (
    SELECT
        d.Year,
        d.Month,
        SUM(s.OrderAmount) AS Revenue,
        SUM(b.BilledAmount) AS BilledRevenue,
        SUM(r.UtilizedHours) AS UtilizedHours
    FROM WebSales s
    JOIN Billing b ON s.OrderID = b.OrderID
    JOIN ResourceUsage r ON s.ProjectID = r.ProjectID
    JOIN DateTable d ON s.OrderDate = d.DateID
    GROUP BY d.Year, d.Month
),

Rolling_Averages AS (
    SELECT
        Year,
        Month,
        Revenue,
        BilledRevenue,
        UtilizedHours,
        AVG(Revenue) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgRevenue_3M,
        AVG(BilledRevenue) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgBilling_3M,
        AVG(UtilizedHours) OVER (ORDER BY Year, Month ROWS BETWEEN 2 PRECEDING AND CURRENT ROW) AS AvgUtilization_3M
    FROM Historical_Performance
)

SELECT
    Year,
    Month,
    Revenue,
    BilledRevenue,
    UtilizedHours,
    AvgRevenue_3M   AS ProjectedRevenue,
    AvgBilling_3M   AS ProjectedBilling,
    AvgUtilization_3M AS ProjectedUtilization
FROM Rolling_Averages
ORDER BY Year, Month;
