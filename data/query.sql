-- #1
select publType, count(publType) as count
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
  having count(c.id) > 200;
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
select a.given_name || a.family_name as name
from author a natural join publication p natural join link_author_publ l
where p.id in (
  select p.id
  from publication p natural join conference c natural join link_conf_publ l
  where c.code = 'Z' and c.year = Y; -- assume that the conference name is short code and year is conference year
)
group by a.given_name || a.family_name as name
having count(a.id) >= 2;

-- #4 (book and article currently not counted)
-- a.
select *
from (
  select a.given_name || a.family_name as name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'pvldb'
  )
  group by a.given_name || a.family_name as name
  having count(a.id) >= 10
) union (
  select a.given_name || a.family_name as name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'sigmod'
  )
  group by a.given_name || a.family_name as name
  having count(a.id) >= 10
);

-- #4
-- b.
select *
from (
  select a.given_name || a.family_name as name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'pvldb'
  )
  group by a.given_name || a.family_name as name
  having count(a.id) >= 15
) union (
  select a.given_name || a.family_name as name
  from publication p natural join author a natural join link_author_publ l
  where p.id in (
    select p.id
    from publication p natural join conference c natural join link_conf_publ l
    where c.code = 'kdd'
  )
  group by a.given_name || a.family_name as name
  having count(a.id) = 0
);

-- #5
select p.decade, count(*)
from publication p natural join conference c natural join link_conf_publ l
where c.code = 'dblp'
group by p.decade
order by p.decade;

-- #6
select a.given_name || a.family_name as name
from publication p natural join author a natural join link_author_publ l
where p.id in (
  select p.id
  from publication p natural join conference c natural join link_conf_publ l
  where c.title like '%data%' and p.noAuthors = MAX(p.noAuthors)
);

-- #7
select a.given_name || a.family_name as name
from publication p natural join author a natural join link_author_publ l
where p.id in (
  select p.id
  from publication p natural join conference c natural join link_conf_publ l
  where c.title like '%data%' and date_part('year', CURRENT_DATE) - p.year <= 5
}
group by a.given_name || a.family_name as name
order by count(a.id) desc
limit 10;

-- #8
select distinct c.title
from publication p natural join conference c natural join link_conf_publ l
where c.month = 'Jun'
group by c.title, c.year, c.month
having count(c.id) >= 100

-- #9
-- a.
select a.given_name || a.family_name as name
from author a 
where a.family_name like 'H%' and 31 = (
  select distinct count(p.year)
  from publication p1 natural join author a1 natural join link_author_publ l1 
  where a1.family_name = a.family_name and a1.given_name = a.given_name and date_part('year', CURRENT_DATE) - p.year <= 30
  group by p.year
)

-- #9
-- b.
select a.given_name || a.family_name as name, count(*)
from publication p natural join author a natural join link_author_publ l
where a.id in (
  select a.id
  from publication p1 natural join author a1 natural join link_author_publ l1 
  where p.year = MIN(p.year)
)

-- #10