create or replace function
	Q6(output char(8)) returns text
as
$$
select code ||' '|| name ||' '|| uoc from Subjects
where Subjects.code = output;

--... SQL statements, possibly using other views/functions defined by you ...
$$ language sql;
