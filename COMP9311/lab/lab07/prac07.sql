

create or replace view AllRatings(taster,beer,brewer,rating)
as
	... replace this by your SQL query ...
;


-- John's favourite beer

create or replace view JohnsFavouriteBeer(brewer,beer)
as
	... replace this by your SQL query ...
;


-- X's favourite beer

create type BeerInfo as (brewer text, beer text);

create or replace function FavouriteBeer(taster text) returns setof BeerInfo
as $$
	... replace this by your SQL query ...
$$ language sql
;


-- Beer style

create or replace function BeerStyle(brewer text, beer text) returns text
as $$
	... replace this by your SQL query ...
$$ language sql
;

create or replace function BeerStyle1(brewer text, beer text) returns text
as $$
begin
	... replace this by your PLpgSQL code ...
end;
$$ language plpgsql
;


-- Taster address

create or replace function TasterAddress(taster text) returns text
as $$
	select loc.state||', '||loc.country
	from   Taster t, Location loc
	where  t.given = $1 and t.livesIn = loc.id
$$ language sql
;

create or replace function TasterAddress(taster text) returns text
as $$
begin
	... replace this by your PLpgSQL code ...
end;
$$ language plpgsql
;


-- BeerSummary function

create or replace function BeerSummary() returns text
as $$
declare
	... replace this by your definitions ...
begin
	... replace this by your code ...
end;
$$ language plpgsql;



-- Concat aggregate

create aggregate concat (... replace by base type ...)
(
	stype     = ... replace by state type ... ,
	initcond  = ... replace by initial state ... ,
	sfunc     = ... replace by name of state transition function ...,
	finalfunc = ... replace by name of finalisation function ...
);


-- BeerSummary view

create or replace view BeerSummary(beer,rating,tasters)
as
	... replace by SQL your query using concat() and AllRatings ...
;


-- TastersByCountry view

create or replace view TastersByCountry(country,tasters)
as
	... replace by SQL your query using concat() and Taster ...
;
