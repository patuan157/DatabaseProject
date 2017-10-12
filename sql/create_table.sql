DROP TABLE IF EXISTS authored;    -- Drop first because of the REFERENCE KEY
DROP TABLE IF EXISTS article;
DROP TABLE IF EXISTS inproceedings;
DROP TABLE IF EXISTS author;
DROP TABLE IF EXISTS journal;
DROP TABLE IF EXISTS conference;
DROP TABLE IF EXISTS publication;

-- Create Table publication --
CREATE TABLE publication(
  pubkey varchar(100) NOT NULL UNIQUE,
  pubtype varchar(20) NOT NULL,
  mdate date,  
  year int,
  numberauthor int DEFAULT 0,
  title text
);

-- Create Table author --
CREATE TABLE author(
  authid SERIAL PRIMARY KEY,
  name text,
  pubkey varchar(100)
);

-- Create Table authored --
CREATE TABLE authored(
  authid int REFERENCES author(authid),
  authname text,
  pubkey varchar(100) REFERENCES publication(pubkey)
);

-- Create Table article --
CREATE TABLE article(
  akey varchar(100) REFERENCES publication(pubkey) PRIMARY KEY,
  mdate date,
  year int,
  numberauthor int DEFAULT 0,
  title text,
  journal_code varchar(100)
);

-- Create Table inproceedings --
CREATE TABLE inproceedings(
  ikey varchar(100) REFERENCES publication(pubkey) PRIMARY KEY,
  mdate date,
  year int,
  numberauthor int DEFAULT 0,
  title text,
  conf_code varchar(100),
  decade varchar(4)
);

-- Create Table conference --
CREATE TABLE conference(
  conferenceid SERIAL PRIMARY KEY,
  conf_code varchar(100),
  publisher text,
  title text,
  year int,
  month int
);

-- Create Table journal --
CREATE TABLE journal(
  journalid SERIAL PRIMARY KEY,
  journal_code varchar(100),
  title text,
  year int,
  month int
);

