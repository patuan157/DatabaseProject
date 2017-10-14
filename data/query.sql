-- #1
select pub_type, count(id) as count
from publication
where year between 2000 and 2017
group by pub_type;

-- #2
select distinct title, month, year
from conference
where month = 7 and id in (
  select c.id
  from conference c, inproceedings i
  where i.conf_id = c.id
  group by c.id
  having count(c.id) > 200
);

-- #3
-- a.
select p.id, p.title, p.month, p.year
from publication p, author a, link_publ_auth lpa
where p.id = lpa.publ_id and a.id = lpa.auth_id and p.year = 2015 and a.id = 'X';

-- b.
select p.id, p.title, p.month, p.year
from publication p, author a, link_publ_auth lpa
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'Z' and p.year = Y and a.id = 'X';

-- c.
select a.id
from publication p, author a, link_publ_auth lpa
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'Z' and p.year = Y
group by a.id
having count(a.id) >= 2;

-- #4 (book and article currently not counted)
-- a.
select a.id
from publication p, author a, link_publ_auth lpa 
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'pvldb'
group by a.id
having count(a.id) >= 10
intersect 
select a.id
from publication p, author a, link_publ_auth lpa 
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'sigmod'
group by a.id
having count(a.id) >= 10

-- #4
-- b.
select a.id
from publication p, author a, link_publ_auth lpa 
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'pvldb'
group by a.id
having count(a.id) >= 15
except
select a.id
from publication p, author a, link_publ_auth lpa 
where p.id = lpa.publ_id and a.id = lpa.auth_id and split_part(p.id, '/', 2) = 'kdd'
group by a.id

-- #5
select decade, count(id)
from publication p
group by decade
order by decade;

-- #6
create view data_max as
select p.id, p.no_authors
from publication p, conference c
where split_part(p.id, '/', 2) = split_part(c.key, '/', 2) and p.month = c.month and p.year = c.year and lower(c.title) like '%data%'
union
select p.id, p.no_authors
from publication p, journal j
where split_part(p.id, '/', 2) = j.code and p.month = j.month and p.year = j.year and lower(j.title) like '%data%';
select a.id
from author a, link_publ_auth lpa 
where lpa.publ_id = (
  select id
  from data_max
  where no_authors = (
    select max(no_authors)
    from data_max
  )
) and a.id = lpa.auth_id;

-- #7
select a.id
from publication p, author a, link_publ_auth lpa
where p.id in (
  select p.id
  from publication p, conference c
  where split_part(p.id, '/', 2) = split_part(c.key, '/', 2) and p.month = c.month and p.year = c.year and lower(c.title) like '%data%' and date_part('year', CURRENT_DATE) - p.year <= 5
  union
  select p.id
  from publication p, journal j
  where split_part(p.id, '/', 2) = j.code and p.month = j.month and p.year = j.year and lower(j.title) like '%data%' and date_part('year', CURRENT_DATE) - p.year <= 5
}
group by a.id
order by count(a.id) desc
limit 10;

-- #8
select distinct c.title
from publication p, conference c
where split_part(p.id, '/', 2) = split_part(c.key, '/', 2) and p.month = 6 and p.year = c.year
group by c.id
having count(c.id) >= 100;

-- #9
-- a.
select a.id
from author a 
where lower(a.family_name) like 'h%' and 31 = (
  select count(*)
  from (
    select p.year
    from publication p, author a1, link_publ_auth lpa 
    where a1.id = lpa.auth_id and p.id = lpa.publ_id and a1.id = a.id and date_part('year', CURRENT_DATE) - p.year <= 30
    group by p.year
  ) as tmp
)

-- #9
-- b.
select a.id, count(*)
from publication p, author a, link_publ_auth lpa
where a.id = lpa.auth_id and p.id = lpa.publ_id and p.year = (
  select min(year)
  from publication
)
group by a.id;

-- #10
-- find all authors who have never published any articles (in journal) within
-- the last 5 years
select a.id
from publication p, author a, link_publ_auth lpa
where p.id = lpa.publ_id and a.id = lpa.auth_id and p.pub_type = 'inproceedings' and date_part('year', CURRENT_DATE) - p.year <= 5
except
select a.id
from publication p, author a, link_publ_auth lpa
where p.id = lpa.publ_id and a.id = lpa.auth_id and p.pub_type = 'article' and date_part('year', CURRENT_DATE) - p.year <= 5
