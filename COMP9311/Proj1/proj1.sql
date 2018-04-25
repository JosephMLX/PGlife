-- COMP9311 18s1 Project 1
--
-- MyMyUNSW Solution Template


-- Q1:
create or replace view Q1(unswid, name)
as
select People.unswid as unswid, People.name as name from People
inner join Students on students.id = People.id
inner join Course_enrolments on students.id = Course_enrolments.student
where stype='intl' and mark >= 85
group by student,People.unswid,People.name
having count(mark) > 20
order by unswid;
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q2:
create or replace view Q2(unswid, name)
as
select Rooms.unswid as unswid, Rooms.longname as name from Rooms
inner join Buildings on buildings.id = Rooms.building
inner join Room_types on Room_types.id = Rooms.rtype
where Buildings.name = 'Computer Science Building' and description = 'Meeting Room' and capacity >= 20;
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q3:
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
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q4:
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
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q5:
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
--... SQL statements, possibly using other views/functions defined by you ...
;

-- Q5:
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
--... SQL statements, possibly using other views/functions defined by you ...
;


-- Q6:
create or replace function Q6(output char(8)) returns text
as
$$
select code ||' '|| name ||' '|| uoc from Subjects
where Subjects.code = output;
--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;



-- Q7:
create or replace view Program_ratio(code,ratio)
as
select program,
      (cast((select count(Program_enrolments.student) from Program_enrolments
      inner join Students on Students.id = Program_enrolments.student
      where Students.stype='intl' and program = rate.program) as float)) * 100
    /
      (cast((select count(Program_enrolments.student) from Program_enrolments
      inner join Students on Students.id = Program_enrolments.student
      where program = rate.program)as float))
    as percent
    from Program_enrolments
    as rate
    group by rate.program;

create or replace view Q7(code,name)
as
select code, name from Programs where id in
  (
    select code from Program_ratio
    where ratio > 50.0
  );
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q8:
create or replace view sum_mark(course, numofmark) as
  select course, count(mark) from Course_enrolments ce
  group by course;

create or replace view selected_courses(course) as
  select course from sum_mark where numofmark > 15;

create or replace view average_mark(course, mark) as
  select course, avg(mark) from Course_enrolments
  where course in
  (
    select course from selected_courses
  )
  group by course;

create or replace view mark_rank(course, mark) as
  select course, mark from average_mark order by mark DESC
  fetch first 1 row only;

create or replace view Q8(code, name, semester) as
  select Subjects.code, Subjects.name, Semesters.name from Subjects
  inner join Courses on Courses.subject = Subjects.id
  inner join Semesters on Semesters.id = Courses.semester
  where Subjects.id in
  (
    select subject from Courses where Courses.id in
    (
      select course from mark_rank
    )
  )
  and Semesters.id in
  (
    select semester from Courses where Courses.id in
    (
      select course from mark_rank
    )
  );
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q9:
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
--... SQL statements, possibly using other views/functions defined by you ...
;



-- Q10:
create or replace view S1_filter(code, name, year)
as
select Subjects.code,Subjects.name, year from Subjects
inner join Courses on Courses.subject = Subjects.id
inner join Semesters on Semesters.id = Courses.semester
where code like 'COMP93%'
and Semesters.year >= 2003
and Semesters.year <= 2012
and Semesters.term = 'S1'
order by Semesters.year;

create or replace view S1_years(code, name, count)
as
select code, name, count(year) as sum from S1_filter
group by code, name;

create or replace view S1_aimed(code, name ,year)
as
select S1_years.code, S1_years.name, S1_filter.year from S1_years
inner join S1_filter on S1_filter.code = S1_years.code
where S1_years.count = 10
order by S1_years.code, S1_filter.year;

create or replace view S2_filter(code, name, year)
as
select Subjects.code,Subjects.name, year from Subjects
inner join Courses on Courses.subject = Subjects.id
inner join Semesters on Semesters.id = Courses.semester
where code like 'COMP93%'
and Semesters.year >= 2003
and Semesters.year <= 2012
and Semesters.term = 'S2'
order by Semesters.year;

create or replace view S2_years(code, name, count)
as
select code, name, count(year) as sum from S2_filter
group by code, name;

create or replace view S2_aimed(code, name ,year)
as
select S2_years.code, S2_years.name, S2_filter.year from S2_years
inner join S2_filter on S2_filter.code = S2_years.code
where S2_years.count = 10
order by S2_years.code, S2_filter.year;

create or replace view final_aimed(code, name, year)
as
select code, name, year from S1_aimed
intersect
select code, name, year from S2_aimed
order by code, year;

create or replace view aimed_code(code)
as
select distinct code from final_aimed;

create or replace view S1_mark_count(code, year, count)
as
select aimed_code.code, Semesters.year, count(mark) from Course_enrolments
inner join Courses on Courses.id = Course_enrolments.course
inner join Semesters on Semesters.id = Courses.semester
inner join Subjects on Subjects.id = Courses.subject
inner join aimed_code on aimed_code.code = Subjects.code
where course in
(
  select id from Courses where subject in
  (
    select id from Subjects where code in
    (
      select code from aimed_code
    )
  )
)
and Semesters.year <= 2012
and Semesters.term = 'S1'
group by Semesters.year, aimed_code.code
order by aimed_code.code, Semesters.year;

create or replace view code_year(code, year)
as
select code, year from S1_mark_count;

create or replace view S1_hd(code ,year, hdcount)
as
select aimed_code.code, Semesters.year, count(mark) from Course_enrolments
inner join Courses on Courses.id = Course_enrolments.course
inner join Semesters on Semesters.id = Courses.semester
inner join Subjects on Subjects.id = Courses.subject
inner join aimed_code on aimed_code.code = Subjects.code
where course in
(
  select id from Courses where subject in
  (
    select id from Subjects where code in
    (
      select code from aimed_code
    )
  )
)
and mark >= 85
and Semesters.term = 'S1'
and Semesters.year <= 2012
group by Semesters.year, aimed_code.code
order by aimed_code.code, Semesters.year;

create or replace view S1_count
as
select * from S1_mark_count left join S1_hd using(code, year);

create or replace view S1_final
as
select code, year, count, (COALESCE(hdcount, 0)) as hdcount from s1_count;

create or replace view S1_rate(code, year, S1_hd_rate)
as
select code, year, cast((cast(hdcount as numeric(4,2)) / cast(count as numeric(4,2)))as numeric(4,2)) from S1_final;

create or replace view S2_mark_count(code, year, count)
as
select aimed_code.code, Semesters.year, count(mark) from Course_enrolments
inner join Courses on Courses.id = Course_enrolments.course
inner join Semesters on Semesters.id = Courses.semester
inner join Subjects on Subjects.id = Courses.subject
inner join aimed_code on aimed_code.code = Subjects.code
where course in
(
  select id from Courses where subject in
  (
    select id from Subjects where code in
    (
      select code from aimed_code
    )
  )
)
and Semesters.year <= 2012
and Semesters.term = 'S2'
group by Semesters.year, aimed_code.code
order by aimed_code.code, Semesters.year;

create or replace view S2_hd(code ,year, hdcount)
as
select aimed_code.code, Semesters.year, count(mark) from Course_enrolments
inner join Courses on Courses.id = Course_enrolments.course
inner join Semesters on Semesters.id = Courses.semester
inner join Subjects on Subjects.id = Courses.subject
inner join aimed_code on aimed_code.code = Subjects.code
where course in
(
  select id from Courses where subject in
  (
    select id from Subjects where code in
    (
      select code from aimed_code
    )
  )
)
and mark >= 85
and Semesters.term = 'S2'
and Semesters.year <= 2012
group by Semesters.year, aimed_code.code
order by aimed_code.code, Semesters.year;

create or replace view S2_count
as
select * from S2_mark_count left join S2_hd using(code, year);

create or replace view S2_final
as
select code, year, count, (COALESCE(hdcount, 0)) as hdcount from S2_count;

create or replace view S2_rate(code, year, S2_hd_rate)
as
select code, year, cast((cast(hdcount as numeric(4,2)) / cast(count as numeric(4,2)))as numeric(4,2)) from S2_final;

create or replace view joint(code, year, s1_hd_rate, s2_hd_rate)
as
select * from S1_rate join S2_rate using(code, year);

create or replace view q10_answer(code, name, year, s1_hd_rate, s2_hd_rate)
as
select joint.code, Subjects.name, cast(joint.year as text), s1_hd_rate, s2_hd_rate from joint
inner join Subjects on Subjects.code = joint.code
order by joint.code, joint.year;

create or replace view Q10(code, name, year, s1_hd_rate, s2_hd_rate)
as
select code, name, substr(year, 3, 4), s1_hd_rate, s2_hd_rate from q10_answer;
--... SQL statements, possibly using other views/functions defined by you ...
;
