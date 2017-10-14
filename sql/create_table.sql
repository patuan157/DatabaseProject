DROP TABLE IF EXISTS link_publ_auth;    -- Drop first because of the REFERENCE KEY
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS inproceedings;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS journal;
DROP TABLE IF EXISTS conference;
DROP TABLE IF EXISTS publication;

-- Create Table publication --
CREATE TABLE publication(
  id text PRIMARY KEY,
  title text NOT NULL,
  month int NOT NULL,  
  year int NOT NULL,
  no_authors int NOT NULL,
  decade varchar(9) NOT NULL,
  pub_type varchar(20) NOT NULL
);

-- Create Table author --
CREATE TABLE author(
  id text PRIMARY KEY,
  family_name text,
  given_name text NOT NULL
);

-- Create Table authored --
CREATE TABLE link_publ_auth(
  id SERIAL PRIMARY KEY,
  auth_id text REFERENCES author(id),
  publ_id text REFERENCES publication(id)
);

-- Create Table article --
CREATE TABLE article(
  id text REFERENCES publication(id) PRIMARY KEY,
  journal_id int NOT NULL
);

-- Create Table inproceedings --
CREATE TABLE inproceedings(
  id text REFERENCES publication(id) PRIMARY KEY,
  conf_id int NOT NULL
);

-- Create Table conference --
CREATE TABLE conference(
  id SERIAL PRIMARY KEY,
  code varchar(100) NOT NULL,
  key text NOT NULL,
  year int NOT NULL,
  month int NOT NULL,
  title text
);

-- Create Table journal --
CREATE TABLE journal(
  id SERIAL PRIMARY KEY,
  code varchar(100) NOT NULL,
  title text NOT NULL,
  year int NOT NULL,
  month int NOT NULL
);


-- TRIGGER AND PROCEDURE SUPPORT THE INSERT DATA --
CREATE OR REPLACE FUNCTION check_journal_year_month_unique()
  RETURNS trigger AS
$$
BEGIN
  IF EXISTS( SELECT code, year, month FROM journal as j
        WHERE j.code = NEW.code AND j.year = NEW.year AND j.month = NEW.month) THEN
  RETURN NULL;
  ELSE RETURN NEW;
  END IF;
END;
$$ 
LANGUAGE 'plpgsql';


CREATE OR REPLACE FUNCTION check_conference_year_month_unique()
  RETURNS trigger AS
$$
BEGIN
  IF EXISTS( SELECT code, year, month FROM conference as c
        WHERE c.code = NEW.code AND c.year = NEW.year AND c.month = NEW.month) THEN
  RETURN NULL;
  ELSE RETURN NEW;
  END IF;
END;
$$
LANGUAGE 'plpgsql';

CREATE TRIGGER unique_journal 
  BEFORE INSERT ON journal
  FOR EACH ROW
  EXECUTE PROCEDURE check_journal_year_month_unique();

CREATE TRIGGER unique_conference
  BEFORE INSERT ON conference
  FOR EACH ROW
  EXECUTE PROCEDURE check_conference_year_month_unique();
