-- subject 3497
-- course 56317

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
