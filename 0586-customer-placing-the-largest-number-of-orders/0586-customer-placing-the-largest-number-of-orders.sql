with cte1 as(
    select 
        customer_number,
        count(order_number) as cnt_odr
    from Orders
    group by customer_number
    order by count(order_number) desc
)
select
    customer_number
from cte1
limit 1;