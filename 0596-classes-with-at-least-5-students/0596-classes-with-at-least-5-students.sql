select class
from (
    select class, count(student) as ttl
    from Courses
    group by class
    having ttl >= 5
) as grp;