<<<<<<< HEAD
create or replace function
	Q6(output char(8)) returns text
as
$$
select code ||' '|| name ||' '|| uoc from Subjects
where Subjects.code = output;

--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;
=======
create or replace function
	Q6(output char(8)) returns text
as
$$
select code ||' '|| name ||' '|| uoc from Subjects
where Subjects.code = output;

--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;
>>>>>>> 28ee0ae16e527dc645073574c1766efac20c6cae
