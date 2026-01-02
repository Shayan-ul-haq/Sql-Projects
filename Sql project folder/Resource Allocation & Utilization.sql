/* =====================================================
   Report Name : Resource Allocation & Utilization
   ===================================================== */

WITH Resource_Hours AS (
    SELECT
        e.EmployeeID,
        e.EmployeeName,
        e.Department,
        SUM(w.WorkedHours) AS TotalWorkedHours,
        SUM(w.AllocatedHours) AS TotalAllocatedHours
    FROM Employees e
    JOIN WorkLogs w ON e.EmployeeID = w.EmployeeID
    GROUP BY e.EmployeeID, e.EmployeeName, e.Department
)

SELECT
    EmployeeID,
    EmployeeName,
    Department,
    TotalAllocatedHours,
    TotalWorkedHours,
    ROUND(
        (TotalWorkedHours * 100.0) / NULLIF(TotalAllocatedHours, 0), 2
    ) AS UtilizationPercentage,
    CASE
        WHEN TotalWorkedHours > TotalAllocatedHours THEN 'Over Utilized'
        WHEN TotalWorkedHours < TotalAllocatedHours THEN 'Under Utilized'
        ELSE 'Optimally Utilized'
    END AS UtilizationStatus
FROM Resource_Hours
ORDER BY UtilizationPercentage DESC;
