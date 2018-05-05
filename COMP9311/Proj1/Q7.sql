<<<<<<< HEAD
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
=======
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
>>>>>>> 28ee0ae16e527dc645073574c1766efac20c6cae
