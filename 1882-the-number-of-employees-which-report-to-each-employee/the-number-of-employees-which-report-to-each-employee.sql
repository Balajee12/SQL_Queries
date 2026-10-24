SELECT
    employee_id,
    name,
    (
        SELECT COUNT(*)
        FROM Employees e2
        WHERE e2.reports_to = e1.employee_id
    ) AS reports_count,
    (
        SELECT ROUND(AVG(age))
        FROM Employees e2
        WHERE e2.reports_to = e1.employee_id
    ) AS average_age
FROM Employees e1
WHERE EXISTS (
    SELECT 1
    FROM Employees e2
    WHERE e2.reports_to = e1.employee_id
)
ORDER BY employee_id;