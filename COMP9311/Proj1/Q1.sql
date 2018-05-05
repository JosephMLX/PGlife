create or replace view Q1(unswid, name) as
select People.unswid as unswid, People.name as name from People
inner join Students on students.id = People.id
inner join Course_enrolments on students.id = Course_enrolments.student
where stype='intl' and mark >= 85
group by student,People.unswid,People.name
having count(mark) > 20
order by unswid;
--... SQL statements, possibly using other views/functions defined by you ...
