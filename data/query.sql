-- #1
select publType, count(*) as count
from publication
where year between 2000 and 2017
group by publType;

-- #2
select distinct conference.title
from conference
where month = 'Jul' and id in (
  select c.id
  from publication p natural join conference c natural join link_conf_publ l
  group by c.id
  having count(*) > 200;
);

-- #3
-- a.
select p.id, p.publType, p.title, p.year
from publication p natural join author a natural join link_author_publ l
where p.year = 2015 and author = 'X';

-- b.
select p.id, p.publType, p.title, p.year
from publication p natural join conference c natural join link_author_publ l
where p.id in (
  select p.id
  from publication p natural join author a natural join link_author_publ l
  where author = 'X';
) and c.year = Y and c.code = 'Z'; -- not sure short code or full title, for now assume that it's short code
-- also publication year or proceedings year, for now assume that it's proceedings year

-- c.
select a.name
from author a natural join publication p natural join link_author_publ l
where p.id in (
  select p.id
  from publication p natural join conference c natural join link_conf_publ l
  where c.code = 'Z' and c.year = Y; -- assume that the conference name is short code and year is conference year
)
group by a.name
having count(*) >= 2;

-- #4 (book and article currently not counted)
-- a.
select *
from (
  select a.name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'pvldb'
  )
  group by a.name
  having count(*) >= 10
) union (
  select a.name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'sigmod'
  )
  group by a.name
  having count(*) >= 10
);