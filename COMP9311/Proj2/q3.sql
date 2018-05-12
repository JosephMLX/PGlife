drop type if exists CourseRecord cascade;
create type CourseRecord as (unswid integer, student_name text, course_records text);
create or replace function Q3_1(org_id integer, num_courses integer, min_score integer)
        returns table(unswid integer, student_name text, course_records text, mark integer, c_id integer) as $$
        -- return 4 arguments, unswid, student_name, course_records, mark
        with
recursive A as (select * from Orgunit_groups where owner = $1
                        union all select Orgunit_groups.* from Orgunit_groups, A where OrgUnit_groups.owner = A.member),


B as (select p.id as p_id, p.unswid, p.name as p_name, su.code,
      su.name as su_name, se.name as se_name, org.name as org_name,
      ce.mark, su.offeredBy, c.id as c_id
      from People p, Students ss, Subjects su, Courses c, Semesters se,
      OrgUnits org, Course_enrolments ce
      where ss.id = p.id
      and ce.student = ss.id
      and c.id = ce.course
      and su.id = c.subject
      and se.id = c.semester
      and org.id = su.offeredBy),

C as (select A.*,B.* from A inner join B on A.member = B.offeredby),

D as (select count(distinct c_id) as count_course, unswid
      from C
      group by unswid
      having count(distinct c_id)>$2),

E as (select C.*, D.count_course from C inner join D on D.unswid = C.unswid),

F as (select E.unswid, p_name, code, su_name, se_name, org_name, mark, offeredBy, c_id
      from E inner join Orgunits
      on E.offeredby = OrgUnits.id
      group by E.unswid, p_name, code, su_name, se_name, mark, org_name, offeredBy, c_id
      having mark>=$3
      order by unswid, mark desc, c_id),

G as (select F.unswid, E.p_name, E.code, E.su_name, E.se_name, E.org_name, E.mark, E.offeredBy, E.c_id
      from E, F
      where E.unswid = F.unswid
      group by F.unswid, E.p_name, E.code, E.su_name, E.se_name, E.org_name, E.mark, E.offeredBy, E.c_id
      order by F.unswid, mark desc, c_id)

select unswid, p_name as student_name, (code||', '||su_name||', '||se_name||', '||org_name) as course_records, mark, c_id
from G
group by unswid, p_name, code, su_name, se_name, org_name, mark, c_id
order by unswid, mark desc nulls last, c_id;
$$ language sql;

create or replace function Q3(org_id integer, num_courses integer, min_score integer)
  returns table(unswid integer, student_name text, course_records text) as $$
declare
  valid_org_id integer;
  is_valid boolean := 'f';
begin
  for valid_org_id in select id from Orgunits
  loop
    if (valid_org_id = org_id) then
      is_valid := 't';
    end if;
  end loop;
  if (is_valid) = 'f' then
    raise exception 'INVALID ORGID';
  end if;
  return query select q3_1.unswid, q3_1.student_name, string_agg(q3_1.course_records||', '||q3_1.mark, chr(10))||chr(10) as course_records
  from (select *, row_number() over(partition by Q3_1.unswid order by Q3_1.unswid) from q3_1($1,$2,$3)) q3_1
  where row_number between 1 and 5
  group by q3_1.unswid, q3_1.student_name
  order by q3_1.unswid;
end;
$$ language plpgsql;
