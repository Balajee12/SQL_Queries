with cte1 as (
    select
        p.product_id,
        case when month(sale_date) in (12, 1, 2) then 'Winter'
        when month(sale_date) in (3, 4, 5) then 'Spring'
        when month(sale_date) in (6, 7, 8) then 'Summer'
        else 'Fall' end as season,
        category,
        sum(quantity) as total_quantity,
        sum(quantity * price)  as total_revenue
    from sales s
    join products p
        on s.product_id = p.product_id
    group by  season, category
),
ranked as (
    select
        season,
        category,
        total_quantity,
        total_revenue,
        ROW_NUMBER() OVER(PARTITION BY season ORDER BY total_quantity DESC, total_revenue DESC) AS rnk
    from cte1
)
select
    season,
    category,
    total_quantity,
    total_revenue
from ranked
where rnk = 1
order by season asc;
