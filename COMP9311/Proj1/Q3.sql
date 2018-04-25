create or replace view Q3(unswid, name)
as
select People.unswid as unswid, People.name as name from People
where People.id in
(
  select staff from Course_staff where Course_staff.course in
  (
    select course from Course_enrolments
    where Course_enrolments.student in
    (
      select Students.id from Students
      inner join People on People.id = Students.id
      where People.name = 'Stefan Bilek'
    )
  )
);
