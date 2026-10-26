# Write your MySQL query statement below
select
    employee_id,
    case when count(*) = 1 then max(department_id)
    else max(case when  primary_flag = 'Y' then department_id end) 
    end as department_id
from Employee
group by employee_id;
