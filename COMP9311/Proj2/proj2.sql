--Q1:

drop type if exists RoomRecord cascade;
create type RoomRecord as (valid_room_number integer, bigger_room_number integer);

create or replace function Q1(course_id integer)
    returns RoomRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare
        print RoomRecord;
        valid_room_number integer := 0;
        bigger_room_number integer := 0;
        enrolled_students integer := 0;
        waiting_students integer := 0;
        more_students integer := 0;
        is_valid boolean := 'f';
        valid_course_id integer;
        R integer;
begin
for valid_course_id in select id from Courses
  loop
    if (valid_course_id = course_id) then
      is_valid := 't';
      enrolled_students := (select count(student) from Course_enrolments
                            where Course_enrolments.course = valid_course_id);
      waiting_students := (select count(student) from Course_enrolment_waitlist
                            where Course_enrolment_waitlist.course = valid_course_id);
      more_students := enrolled_students + waiting_students;
    end if;
  end loop;
if (is_valid) = 'f' then
  raise exception 'INVALID COURSEID';
end if;
for R in select capacity from Rooms
loop
  if (R >= enrolled_students) then
    valid_room_number := valid_room_number + 1;
  end if;
  if (R >= more_students) then
    bigger_room_number := bigger_room_number + 1;
  end if;
end loop;
print := (valid_room_number, bigger_room_number);
return print;
end;
$$ language plpgsql;



--Q2:

drop type if exists TeachingRecord cascade;
create type TeachingRecord as (cid integer, term char(4), code char(8), name text, uoc integer, average_mark integer, highest_mark integer, median_mark integer, totalEnrols integer);

create or replace view course_details(raw_cid, raw_term, raw_code, raw_name, raw_uoc, raw_staff, raw_te)
as
select Courses.id, substr(cast(Semesters.year as char(4)), 3, 4)|| '' ||lower(Semesters.term), Subjects.code, Subjects.name, Subjects.uoc, Staff.id, count(mark) from Staff
inner join Course_staff on Course_staff.staff = Staff.id
inner join Courses on Courses.id = Course_staff.course
inner join Subjects on Subjects.id = Courses.subject
inner join Course_enrolments on Course_enrolments.course = Courses.id
inner join Semesters on Semesters.id = Courses.semester
group by Courses.id, Semesters.year, Semesters.term, Subjects.code, Subjects.name, Subjects.uoc, Staff.id
order by Courses.id;

create or replace function cal_avg_mark(the_course integer)
	returns numeric
as $$
select round(avg(mark)) from Course_enrolments where course = the_course;
$$ language sql;

create or replace function cal_highest_mark(the_course integer)
	returns integer
as $$
select max(mark) from Course_enrolments where course = the_course;
$$ language sql;

create or replace function cal_median_mark(the_course integer)
	returns numeric
as $$
declare
				r_mark integer;
				mark_list int [];
				m_mark integer;
				length integer;
begin
	for r_mark in select mark from Course_enrolments where course = the_course and mark is not null order by mark
	loop
		mark_list := array_append(mark_list, r_mark);
	end loop;
	length := array_length(mark_list, 1);
	if (length % 2 <> 0) then
		m_mark := mark_list[(length + 1) / 2];
	else
		m_mark := round((mark_list[length / 2] + mark_list[length / 2 + 1]) / 2);
	end if;
return m_mark;
end;
$$ language plpgsql;

create or replace function Q2(staff_id integer)
	returns setof TeachingRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
declare
				print TeachingRecord;
				valia_staff_id integer;
				is_valid boolean := 'f';
				taught_course record;
begin
for valia_staff_id in select id from Staff
	loop
		if (valia_staff_id = staff_id) then
			is_valid := 't';
		end if;
	end loop;
if (is_valid) = 'f' then
	raise exception 'INVALID STAFFID';
end if;
for taught_course in select * from course_details where course_details.raw_staff = staff_id and raw_te <> 0
loop
		print.cid := taught_course.raw_cid;
		print.term := taught_course.raw_term;
		print.code := taught_course.raw_code;
		print.name := taught_course.raw_name;
		print.uoc := taught_course.raw_uoc;
		print.average_mark := cal_avg_mark(print.cid);
		print.highest_mark := cal_highest_mark(print.cid);
		print.median_mark := cal_median_mark(print.cid);
		print.totalEnrols := taught_course.raw_te;
return next print;
end loop;
end;
$$ language plpgsql;



--Q3:

drop type if exists CourseRecord cascade;
create type CourseRecord as (unswid integer, student_name text, course_records text);

create or replace function Q3(org_id integer, num_courses integer, min_score integer)
  returns setof CourseRecord
as $$
--... SQL statements, possibly using other views/functions defined by you ...
$$ language plpgsql;
