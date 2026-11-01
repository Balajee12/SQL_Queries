select
    Department,
    Employee,
    Salary
from (
    select
        d.name as Department,
        e.name as Employee,
        salary,
        dense_rank() over(partition by departmentId order by salary desc) as rnk
    from Employee e
    join Department d
        on e.departmentId = d.id
)as a
where rnk = 1;