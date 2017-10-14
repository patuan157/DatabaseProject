## Synopsis
CZ4031 : Database System Principle - Project 1
- Process large data file from dblp by SAX parser into PostgreSQL database
- Process some query with and without the implementation of Indexing
- Find out how caches effect database performance

## Installation/Setup
Requirement:
- Python 3.6
- PosgresSQL (local)
	+ MacOS : https://gist.github.com/sgnl/609557ebacd3378f3b72
	+ Window : https://www.labkey.org/Documentation/wiki-page.view?name=installPostgreSQLWindows

## Running Instruction
- Get the data file into data folder : dblp.xml
- Open file sql/load_data.sql: Fix 2 absolute dir of the COPY statement to fit your own machine
- Create new database on Postgresql : createdb db_project1
- Run : python load_data.xml sample.xml (Change to dblp.xml for all data)
- Access database : psql -d db_project1
- Access Postgresql command line : psql -d db_project1
- Load Temporary Data : \i sql/load_tmp_data.sql
- Table Creation : \i sql/create_table.sql
- Load Real Data : \i sql/load_data.sql
- Check Table : \dt 
- Quit psql : \q

## Contributors
......
