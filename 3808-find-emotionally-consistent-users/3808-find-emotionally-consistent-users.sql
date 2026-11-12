WITH red AS (
    SELECT
        user_id,
        reaction,
        COUNT(content_id) AS cnt,
        COUNT(reaction) AS cnr
    FROM reactions
    GROUP BY user_id, reaction
),

ranked AS (
    SELECT
        user_id,
        reaction,
        cnr,
        SUM(cnt) OVER (PARTITION BY user_id) AS total_cnt,
        ROW_NUMBER() OVER (
            PARTITION BY user_id
            ORDER BY cnr DESC, reaction ASC
        ) AS rn
    FROM red
)

SELECT
    user_id,
    reaction AS dominant_reaction,
    ROUND(cnr / total_cnt, 2) AS reaction_ratio
FROM ranked
WHERE rn = 1
  AND total_cnt >= 5
  AND cnr / total_cnt >= 0.60
ORDER BY reaction_ratio DESC, user_id ASC;