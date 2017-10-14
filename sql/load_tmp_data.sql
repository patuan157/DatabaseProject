\set home_dir '/Users/AnhTuan/Desktop'
\set pubFile :home_dir '/DatabaseProject/tmpData/pubFile.csv' 
\set fieldFile :home_dir '/DatabaseProject/tmpData/fieldFile.csv' 

DROP TABLE IF EXISTS temppublication;

CREATE TABLE temppublication (
  id text PRIMARY KEY,
  title text NOT NULL,
  month int NOT NULL,  
  year int NOT NULL,
  decade varchar(9) NOT NULL,
  pubtype varchar(20) NOT NULL,
  code text NOT NULL,
  no_authors int NOT NULL
);

DROP TABLE IF EXISTS tempfield;

CREATE TABLE tempfield(
  fieldid SERIAL PRIMARY KEY,
  fieldname VARCHAR(20) NOT NULL ,
  pubkey text NOT NULL,
  value text
);

COPY temppublication(id, title, month, year, decade, pubtype, code, no_authors)
  FROM :'pubFile' 
  (FORMAT CSV, DELIMITER('|'), QUOTE(E'\b'), HEADER );

COPY tempfield(fieldname, pubkey, value) 
  FROM :'fieldFile'
  (FORMAT CSV, DELIMITER('|'), QUOTE(E'\b'), HEADER );


