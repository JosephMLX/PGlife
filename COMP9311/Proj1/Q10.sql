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
