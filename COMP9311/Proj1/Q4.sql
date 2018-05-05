<<<<<<< HEAD
create or replace view Q4(unswid, name) 
as
select People.unswid as unswid, People.name as name from People
inner join Students on Students.id = People.id
where Students.id in(
  select student from Course_enrolments where course in
  (
    select id from Courses where subject in
    (
      select id from Subjects where code = 'COMP3331'
    )
  )
  except select student from Course_enrolments where course in
  (
    select id from Courses where subject in(
      select id from Subjects where code = 'COMP3231'
    )
  )
);
=======
create or replace view Q4(unswid, name) 
as
select People.unswid as unswid, People.name as name from People
inner join Students on Students.id = People.id
where Students.id in(
  select student from Course_enrolments where course in
  (
    select id from Courses where subject in
    (
      select id from Subjects where code = 'COMP3331'
    )
  )
  except select student from Course_enrolments where course in
  (
    select id from Courses where subject in(
      select id from Subjects where code = 'COMP3231'
    )
  )
);
>>>>>>> 28ee0ae16e527dc645073574c1766efac20c6cae
