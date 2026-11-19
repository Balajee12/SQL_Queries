select id 
from (
    select id, recordDate, temperature,
    lag(recordDate) over(order by recordDate) as prev_date,
    lag(temperature) over(order by recordDate) as prev
    from Weather
) as temp_table
where temperature > prev and datediff(recordDate,prev_date) = 1;