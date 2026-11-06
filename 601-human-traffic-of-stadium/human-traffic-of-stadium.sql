with visit_cte as (
    select id, visit_date, people,
    row_number() over () as row_num,
    id - row_number() over () as diff
    from Stadium
    where people >= 100
)
select id, visit_date, people from visit_cte where diff in(
    select diff from visit_cte
    group by diff
    having count(*) >= 3
);