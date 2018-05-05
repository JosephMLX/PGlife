<<<<<<< HEAD
create or replace view Q5a(num)
as
select count(People.id) from People
inner join Students on Students.id = People.id
where Students.stype = 'local' and Students.id in(
  select student from Program_enrolments
  where id in
  (
    select partOf from Stream_enrolments where stream in
    (
      select id from Streams where name = 'Chemistry'
    )
  )
  and semester in
  (
    select id from Semesters where year='2011' and term = 'S1'
  )
);

create or replace view Q5b(num)
as
select count(People.id) from People
inner join Students on Students.id = People.id
where Students.stype = 'intl' and Students.id in(
  select student from Program_enrolments
  where program in
  (
    select id from Programs where offeredBy in
    (
      select id from OrgUnits where name like 'Computer%'
    )
  )
  and semester in
  (
    select id from Semesters where year='2011' and term = 'S1'
  )
);
=======
create or replace view Q5a(num)
as
select count(People.id) from People
inner join Students on Students.id = People.id
where Students.stype = 'local' and Students.id in(
  select student from Program_enrolments
  where id in
  (
    select partOf from Stream_enrolments where stream in
    (
      select id from Streams where name = 'Chemistry'
    )
  )
  and semester in
  (
    select id from Semesters where year='2011' and term = 'S1'
  )
);

create or replace view Q5b(num)
as
select count(People.id) from People
inner join Students on Students.id = People.id
where Students.stype = 'intl' and Students.id in(
  select student from Program_enrolments
  where program in
  (
    select id from Programs where offeredBy in
    (
      select id from OrgUnits where name like 'Computer%'
    )
  )
  and semester in
  (
    select id from Semesters where year='2011' and term = 'S1'
  )
);
>>>>>>> 28ee0ae16e527dc645073574c1766efac20c6cae
