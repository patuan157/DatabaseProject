## Synopsis
CZ4031 : Database System Principle - Project 1
- Process large data file from dblp by SAX parser into MySQL database
- Process some query with and without the implementation of Indexing
- Find out how caches effect database performance

## Installation/Setup
Requirement:
- Python 3.6
- MySQL (local)

## Running Instruction
- Setup MySQL database with default user "root" and create database for project name db_project
- Get the data file into data folder : dblp.xml and dblp.dtd
- Run : python load_data.xml
- Access MySQL command line using : mysql -u root -p --local-infile db_project
- Load Data : source sql/load_data.sql

## Contributors
......
