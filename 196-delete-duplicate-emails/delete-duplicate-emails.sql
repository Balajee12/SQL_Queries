delete from Person
where id in (
  select id
  from (
    select D.id
    from Person p, Person D
    where p.email = D.email
    and p.id < D.id
  ) as duplicates
);