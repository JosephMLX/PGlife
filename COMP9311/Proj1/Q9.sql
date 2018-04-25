-- 34
create or replace view first_step(id)
as
select Staff.id from Staff
inner join People on Staff.id = People.id
inner join Affiliations on Affiliations.staff = Staff.id
where role in
(
  select id from Staff_roles where name = 'Head of School'
)
and ending is null
and isPrimary = 't'
and orgUnit in
(
  select id from OrgUnits where utype in
  (
    select id from OrgUnit_types where name = 'School'
  )
)
order by id;

create or replace view second_step(id,num_subjects)
as
select first_step.id, count(distinct code) from Subjects
inner join Courses on Courses.subject = Subjects.id
inner join Course_staff on Course_staff.course = Courses.id
inner join Staff on Course_staff.staff = Staff.id
inner join People on People.id = Staff.id
inner join first_step on first_step.id = Staff.id
where Subjects.id in
(
  select subject from Courses where id in
  (
    select course from Course_staff where Course_staff.staff in
    (
      select * from first_step
    )
  )
)
group by first_step.id
order by first_step.id;

select second_step.id, starting from Affiliations
inner join staff on Affiliations.staff = staff.id
inner join second_step on second_step.id = staff.id
where staff in(
  select id from second_step
);

create or replace view Q9(name, school, email, starting, num_subjects)
as
select People.name, longname, People.email, Affiliations.starting, num_subjects from People
inner join Staff on Staff.id = People.id
inner join Affiliations on Affiliations.staff = Staff.id
inner join OrgUnits on OrgUnits.id = Affiliations.orgUnit
inner join OrgUnit_types on OrgUnit_types.id = OrgUnits.utype
inner join second_step on second_step.id = Staff.id
where People.id in
(
  select id from second_step
)
and OrgUnit_types.name = 'School'
and Affiliations.ending is null
and Affiliations.isPrimary = 't';
