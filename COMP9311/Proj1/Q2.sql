<<<<<<< HEAD
create or replace view Q2(unswid, name)
as
select Rooms.unswid as unswid, Rooms.longname as name from Rooms
inner join Buildings on buildings.id = Rooms.building
inner join Room_types on Room_types.id = Rooms.rtype
where Buildings.name = 'Computer Science Building' and description = 'Meeting Room' and capacity >= 20;
=======
create or replace view Q2(unswid, name)
as
select Rooms.unswid as unswid, Rooms.longname as name from Rooms
inner join Buildings on buildings.id = Rooms.building
inner join Room_types on Room_types.id = Rooms.rtype
where Buildings.name = 'Computer Science Building' and description = 'Meeting Room' and capacity >= 20;
>>>>>>> 28ee0ae16e527dc645073574c1766efac20c6cae
