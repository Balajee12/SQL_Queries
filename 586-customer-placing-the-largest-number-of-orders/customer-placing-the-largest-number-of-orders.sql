select customer_number
from(
    select customer_number, count(order_number) as ttl
    from Orders
    group by customer_number
) as grp
order by ttl desc
limit 1;
