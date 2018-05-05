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
