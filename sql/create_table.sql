DROP TABLE IF EXISTS authored;    -- Drop first because of the REFERENCE KEY
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
  mdate date NOT NULL,  
  year int NOT NULL,
  no_authors int NOT NULL,
  decade varchar(9) NOT NULL
);

-- Create Table author --
CREATE TABLE author(
  id text PRIMARY KEY,
  family_name text,
  give_name text NOT NULL
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
  journal_id text NOT NULL
);

-- Create Table inproceedings --
CREATE TABLE inproceedings(
  id text REFERENCES publication(id) PRIMARY KEY,
  conf_id text NOT NULL
);

-- Create Table conference --
CREATE TABLE conference(
  id SERIAL PRIMARY KEY,
  code varchar(100) NOT NULL,
  title text NOT NULL,
  year int NOT NULL,
  month int NOT NULL
);

-- Create Table journal --
CREATE TABLE journal(
  id SERIAL PRIMARY KEY,
  code varchar(100),
  title text NOT NULL,
  year int NOT NULL,
  month int NOT NULL
);

