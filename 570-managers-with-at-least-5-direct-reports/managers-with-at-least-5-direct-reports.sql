SELECT 
    m.name
from Employee e
inner  join Employee m
    on e.managerId =  m.id
group by e.managerId
having count(e.id)  >=5;