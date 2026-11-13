select
    d.name as Department,
    e.name as Employee,
    salary
from (
    select
        name,
        salary,
        departmentId,
        dense_rank() over(partition by departmentId order by salary desc
        ) as rnk
    from Employee
)e
join Department d
    on e.departmentId = d.id
where rnk <=3;