
DROP TABLE IF EXISTS temppublication;

CREATE TABLE temppublication (
  pubid SERIAL PRIMARY KEY,
  pubkey varchar(50) NOT NULL,
  pubtype varchar(20) NOT NULL,
  mdate date
);

DROP TABLE IF EXISTS tempfield;

CREATE TABLE tempfield(
  fieldid SERIAL PRIMARY KEY,
  fieldname VARCHAR(20) NOT NULL ,
  pubkey VARCHAR(50) NOT NULL,
  value text
);

COPY temppublication(pubkey, mdate, pubtype) 
  FROM '/Users/AnhTuan/Desktop/DatabaseProject/tmpData/pubFile.csv' 
  (FORMAT CSV, DELIMITER('|'), HEADER );

COPY tempfield(fieldname, pubkey, value) 
  FROM '/Users/AnhTuan/Desktop/DatabaseProject/tmpData/fieldFile.csv' 
  (FORMAT CSV, DELIMITER('|'), HEADER );


-- Create Table Publication
DROP TABLE IF EXISTS publication;

CREATE TABLE publication(
  pubid SERIAL PRIMARY KEY ,
  pubkey varchar(50) NOT NULL UNIQUE ,
  pubtype varchar(20) NOT NULL ,
  mdate date,
  title text,
  year char(4)
);

-- Data Transformation from Temporary Table, which add some more column to Real Table we will use for query
INSERT INTO publication (
  SELECT DISTINCT tp.pubid,
    tp.pubkey,
    tp.pubtype,
    tp.mdate,
    tf1.value,
    tf2.value
  FROM temppublication as tp, tempfield as tf1, tempfield as tf2
  WHERE tp.pubkey = tf1.pubkey AND tp.pubkey = tf2.pubkey AND
        tf1.fieldname = 'title' AND tf2.fieldname = 'year'
);


