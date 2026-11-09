WITH separate AS (
    SELECT
        e.employee_id,
        e.name,
        p.rating,
        p.review_date,
        ROW_NUMBER() OVER (
            PARTITION BY e.employee_id
            ORDER BY p.review_date DESC
        ) AS rnk
    FROM employees e
    JOIN performance_reviews p
        ON e.employee_id = p.employee_id
),

ranked AS (
    SELECT
        employee_id,
        name,
        MAX(CASE WHEN rnk = 1 THEN rating END) AS latest_rating,
        MAX(CASE WHEN rnk = 2 THEN rating END) AS middle_rating,
        MAX(CASE WHEN rnk = 3 THEN rating END) AS earliest_rating
    FROM separate
    WHERE rnk <= 3
    GROUP BY employee_id, name
    HAVING COUNT(*) = 3
)

SELECT
    employee_id,
    name,
    latest_rating - earliest_rating AS improvement_score
FROM ranked
WHERE latest_rating > middle_rating
  AND middle_rating > earliest_rating
ORDER BY improvement_score DESC, name ASC;