WITH ranked_sessions AS (
    SELECT
        student_id,
        session_id,
        session_date,
        subject,
        hours_studied,

        ROW_NUMBER() OVER (
            PARTITION BY student_id
            ORDER BY session_date, session_id
        ) AS rn,

        DATEDIFF(
            session_date,
            LAG(session_date) OVER (
                PARTITION BY student_id
                ORDER BY session_date, session_id
            )
        ) AS date_diff

    FROM study_sessions
),

contiguous_students AS (
    SELECT student_id
    FROM ranked_sessions
    GROUP BY student_id
    HAVING SUM(
        CASE
            WHEN date_diff > 2 THEN 1
            ELSE 0
        END
    ) = 0
),

student_stats AS (
    SELECT
        r.student_id,
        COUNT(*) AS session_count,
        COUNT(DISTINCT r.subject) AS cycle_length,
        SUM(r.hours_studied) AS total_hours

    FROM ranked_sessions r
    JOIN contiguous_students c
        ON r.student_id = c.student_id

    GROUP BY r.student_id

    HAVING
        COUNT(DISTINCT r.subject) >= 3
        AND COUNT(*) >= 2 * COUNT(DISTINCT r.subject)
        AND COUNT(*) % COUNT(DISTINCT r.subject) = 0
)

SELECT
    s.student_id,
    s.student_name,
    s.major,
    st.cycle_length,
    st.total_hours AS total_study_hours

FROM student_stats st
JOIN students s
    ON s.student_id = st.student_id

WHERE NOT EXISTS (
    SELECT 1
    FROM ranked_sessions cur
    JOIN ranked_sessions cyc
        ON cyc.student_id = cur.student_id
        AND cyc.rn = (cur.rn - 1) % st.cycle_length + 1

    WHERE cur.student_id = st.student_id
      AND NOT (cur.subject <=> cyc.subject)
)

ORDER BY
    st.cycle_length DESC,
    st.total_hours DESC;