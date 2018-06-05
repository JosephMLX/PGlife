--Q1:

drop type if exists RoomRecord cascade;
create type RoomRecord as (valid_room_number integer, bigger_room_number integer);

create or replace function Q1(course_id integer)
    returns RoomRecord
as $$
declare
        rec RoomRecord;
		_count integer;
begin
	if (course_id is null) then
                raise exception 'INVALID COURSEID';
       end if;

    select count(*) into _count
        from courses where id = course_id;
    if (_count = 0) then
                raise exception 'INVALID COURSEID';
    end if;

    select count(distinct id) into rec.valid_room_number
    from rooms
    where (rooms.capacity >= (select count(distinct student) from Course_enrolments
		where course = course_id));

    select count(*) into rec.bigger_room_number
    from rooms
    where (rooms.capacity >= (select count(distinct student) from Course_enrolments
		where course = course_id) + (select count(distinct student) from Course_enrolment_waitlist
		where course = course_id));

        return rec;
end;
$$ language plpgsql;

--Q2:

drop type if exists TeachingRecord cascade;
create type TeachingRecord as (cid integer, term char(4), code char(8), name text, uoc integer, average_mark integer, highest_mark integer, median_mark integer, totalEnrols integer);

create or replace function Q2(staff_id integer)
	returns setof TeachingRecord
as $$
declare
	rec TeachingRecord;
	total_marks real;
	_count integer;
	marks integer[] := ARRAY[]::integer[];
	i integer;
	oneMark integer;
begin
	if (staff_id is null) then
                raise exception 'INVALID STAFFID';
    end if;

	select count(*) into _count
		from   Staff s where id = staff_id;
    if (_count = 0) then
			raise EXCEPTION 'INVALID STAFFID';
	end if;

	for rec in
		select c.id,
				 substr(t.year::text,3,2)||lower(t.term),
		         su.code,
		         su.name,
				 su.uoc,
		         0,
		         0,
		         0,
				 0
		from   Course_staff s
		         join Courses c on (c.id = s.course)
		         join Subjects su on (c.subject = su.id)
		         join Semesters t on (c.semester = t.id)
		where  s.staff = staff_id
		order  by t.starting, su.code
	loop
		
		select count(distinct student) into rec.totalEnrols from Course_enrolments
			where course = rec.cid and mark is not null;

		if (rec.totalEnrols = 0) then
			continue;
		end if;

		select sum(mark) into total_marks from Course_enrolments e
		where course = rec.cid and mark is not null;

		select max(mark) into rec.highest_mark from Course_enrolments e
		where course = rec.cid and mark is not null;

		select array(select e.mark from Course_enrolments e
			where course = rec.cid and mark is not null 
			order by e.mark) into marks;

		if (mod(rec.totalEnrols, 2) = 1) then
			for i in 1..array_length(marks, 1) loop
				if (i = rec.totalEnrols / 2 + 1) then
					rec.median_mark := marks[i];
				end if;
			end loop;  
		end if;

		if (mod(rec.totalEnrols, 2) = 0) then
			for i in 1..array_length(marks, 1) loop
				if (i = rec.totalEnrols / 2) then
					rec.median_mark := marks[i];
				end if;
				if (i = rec.totalEnrols / 2 + 1) then
					rec.median_mark := rec.median_mark + marks[i];
				end if;
			end loop;  
			rec.median_mark = ROUND(rec.median_mark / 2.0);
		end if;

		rec.average_mark := ROUND(total_marks / rec.totalEnrols);

		return next rec;
	end loop;

end;
$$ language plpgsql;

--Q3:

CREATE OR REPLACE FUNCTION findChildren(_ouid integer) 
	returns integer[]
as $$
declare
	child integer;
	children integer[] := ARRAY[]::integer[];
	childId integer := 0;
begin
	for child in select og.member 
		from orgunits o 
		join orgunit_groups og on (o.id = og.member)
		where og.owner = _ouid
	loop
		childId := childId + 1;
		children[childId] := child;
	end loop;
	if (childId > 0) then
		for i in 1 .. childId
		loop
			if(children[i] > 0) then
				children := children || findChildren(children[i]);
			end if;
		end loop;
	end if;
	return children;
end;
$$ language plpgsql;


CREATE OR REPLACE FUNCTION collectOrgunits(_ouid integer) 
	returns setof integer
as $$
declare
	_orgs integer[];
	_count integer;
begin
	if (_ouid is null) then
                raise exception 'INVALID ORGID';
        end if;

        select count(*) into _count
        from OrgUnits where id = _ouid;
        if (_count = 0) then
                raise exception 'INVALID ORGID';
        end if;
	_orgs := findChildren(_ouid);
	if(_ouid > 0) then
		return next _ouid;
	end if;
	if(array_length(_orgs, 1) > 0) then
		for i in 1 .. array_length(_orgs, 1)
		loop
			return next _orgs[i];
		end loop;
	end if;
end;
$$ language plpgsql;


drop type if exists CourseRecord cascade;
create type CourseRecord as (unswid integer, student_name text, course_records text);

drop type if exists TempRecord cascade;
create type TempRecord as (unswid integer, student_name text, semester text, code char(8), course_name text, times integer, score integer, orgname text);


create or replace function Q3(org_id integer, num_courses integer, min_score integer)
	returns setof CourseRecord
as $$
declare
	rec CourseRecord;
	trec TempRecord;
	trec2 TempRecord;
	i integer;
	numDisplay integer := 5;
	curStudent integer := 0;
	numSubject integer := 1;
	curTimes integer := 1;
	curRecs TempRecord[] := ARRAY[]::TempRecord[];
	curScoreLegal integer := 0;
	curScore integer := 0;
	th_courses integer;
	th_score integer;
begin
	th_courses := $2;
	th_score := $3;
	for trec in
		select People.unswid, People.name, Semesters.name, Subjects.code, Subjects.name, 0 as times, Course_enrolments.mark, Orgunits.name
		from People
			join Students on (People.id = Students.id)
			join Course_enrolments on (Course_enrolments.student = Students.id)
			join Courses on (Courses.id = Course_enrolments.course)
			join Semesters on (Semesters.id = Courses.semester)
			join Subjects on (Subjects.id = Courses.subject)
			left outer join Orgunits on (Subjects.offeredBy = Orgunits.id)
		where Orgunits.id in (select * from collectOrgunits($1))
		order by People.unswid, Course_enrolments.mark desc nulls last, Courses.id
	loop
		if(curStudent = 0) then
			curStudent := trec.unswid;
			curTimes := 1;
			if (trec.score is not null) then
				curScore := trec.score;
				if (curScore >= th_score) then
					curScoreLegal := 1;
				end if;
			end if;
			curRecs := ARRAY[]::TempRecord[];
			curRecs[1] := trec;
		else
			if(trec.unswid = curStudent) then
				trec2 := curRecs[numSubject];
				trec2.times := curTimes;
				curRecs[numSubject] := trec2;
				numSubject := numSubject + 1;
				if (trec.score is not null) then
				curScore := trec.score;
					if (curScore >= th_score) then
						curScoreLegal := 1;
					end if;
				end if;
				curTimes := curTimes + 1;
				curRecs[numSubject] := trec;
			else
				trec2 := curRecs[numSubject];
				trec2.times := curTimes;
				curRecs[numSubject] := trec2;
				if(numSubject > th_courses) then
					if (curScoreLegal = 1) then
						rec.unswid := curStudent;
						rec.student_name := curRecs[1].student_name;
						if (curRecs[1].score is null) then
							rec.course_records := curRecs[1].code || ', ' || curRecs[1].course_name || ', ' || curRecs[1].semester || ', ' || curRecs[1].orgname || ', ' || 'null' || E'\n';
						else
							rec.course_records := curRecs[1].code || ', ' || curRecs[1].course_name || ', ' || curRecs[1].semester || ', ' || curRecs[1].orgname || ', ' || curRecs[1].score || E'\n';
						end if;						
						if (numDisplay > array_length(curRecs, 1)) then
							numDisplay := array_length(curRecs, 1);
						end if;
						for i in 2..numDisplay loop
							if (curRecs[i].score is null) then
								rec.course_records := rec.course_records || curRecs[i].code || ', ' || curRecs[i].course_name || ', ' || curRecs[i].semester || ', ' || curRecs[i].orgname || ', ' || 'null' || E'\n';
							else
								rec.course_records := rec.course_records || curRecs[i].code || ', ' || curRecs[i].course_name || ', ' || curRecs[i].semester || ', ' || curRecs[i].orgname || ', ' || curRecs[i].score || E'\n';
							end if;
						end loop;
						if(rec.course_records <> '') then
							return next rec;
						end if;
					end if;
				end if;
				curStudent := trec.unswid;
				numSubject := 1;
				curTimes := 1;
				curRecs := ARRAY[]::TempRecord[];
				curRecs[1] := trec;
				numDisplay := 5;
				curScoreLegal := 0;
				if (trec.score is not null) then
				curScore := trec.score;
					if (curScore >= th_score) then
						curScoreLegal := 1;
					end if;
				end if;
			end if;
		end if;
	end loop;
	trec2 := curRecs[numSubject];
	trec2.times := curTimes;
	curRecs[numSubject] := trec2;
	if(numSubject > th_courses) then
		if (curScoreLegal = 1) then
			rec.unswid := curStudent;
			rec.student_name := curRecs[1].student_name;
			if (curRecs[1].score is null) then
				rec.course_records := curRecs[1].code || ', ' || curRecs[1].course_name || ', ' || curRecs[1].semester || ', ' || curRecs[1].orgname || ', ' || 'null' || E'\n';
			else
				rec.course_records := curRecs[1].code || ', ' || curRecs[1].course_name || ', ' || curRecs[1].semester || ', ' || curRecs[1].orgname || ', ' || curRecs[1].score || E'\n';
			end if;						
			if (numDisplay > array_length(curRecs, 1)) then
				numDisplay := array_length(curRecs, 1);
			end if;
			for i in 2..numDisplay loop
				if (curRecs[i].score is null) then
					rec.course_records := rec.course_records || curRecs[i].code || ', ' || curRecs[i].course_name || ', ' || curRecs[i].semester || ', ' || curRecs[i].orgname || ', ' || 'null' || E'\n';
				else
					rec.course_records := rec.course_records || curRecs[i].code || ', ' || curRecs[i].course_name || ', ' || curRecs[i].semester || ', ' || curRecs[i].orgname || ', ' || curRecs[i].score || E'\n';
				end if;
			end loop;
			if(rec.course_records <> '') then
				return next rec;
			end if;
		end if;
	end if;
end;
$$ language plpgsql;
