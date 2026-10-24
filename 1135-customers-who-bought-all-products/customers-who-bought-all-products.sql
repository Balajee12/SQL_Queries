with cte1 as (select
    customer_id,
    count(distinct(product_key))
from Customer 
group by customer_id
having count(distinct(product_key)) = (
    select count(product_key)
    from Product
)
)
select
    customer_id
from cte1;