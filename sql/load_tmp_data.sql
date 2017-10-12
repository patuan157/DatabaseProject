
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


