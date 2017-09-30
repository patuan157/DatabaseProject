-- SET @PUB_FILE_DIR='/Users/AnhTuan/Desktop/DatabaseProject/tmpData/pubFile.csv';
-- SET @FIELD_FILE_DIR='/Users/AnhTuan/Desktop/DatabaseProject/tmpData/fieldFile.csv';

USE db_project;

DROP TABLE IF EXISTS TempPublication;

CREATE TABLE TempPublication (
  PubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  PubKey VARCHAR(50) NOT NULL,
  PubType VARCHAR(20) NOT NULL,
  MDate VARCHAR(30)
);

DROP TABLE IF EXISTS TempField;

CREATE TABLE TempField(
  FieldID INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
  FieldName VARCHAR(20) NOT NULL ,
  PubKey VARCHAR(50) NOT NULL,
  Value TEXT
);

# Load Data Into Temporary Publication Table
LOAD DATA LOCAL
  INFILE '/Users/mrawesome/Projects/db-principle/DatabaseProject/tmpData/pubFile.csv'
  INTO TABLE TempPublication
  COLUMNS TERMINATED BY '||'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (PubKey, MDate, PubType);

# Load Data Into Temporary Field Table
LOAD DATA LOCAL
  INFILE '/Users/mrawesome/Projects/db-principle/DatabaseProject/tmpData/fieldFile.csv'
  INTO TABLE TempField
  COLUMNS TERMINATED BY '||'
  LINES TERMINATED BY '\n'
  IGNORE 1 LINES
  (FieldName, PubKey, Value);

# Data Will be Re-Transform Now
# Create Table Publication
DROP TABLE IF EXISTS Publication;

CREATE TABLE Publication(
  PubID INT NOT NULL AUTO_INCREMENT PRIMARY KEY ,
  PubKey VARCHAR(50) NOT NULL UNIQUE ,
  PubType VARCHAR(20) NOT NULL ,
  MDate DATE,
  Title TEXT,
  Year CHAR(4)
);

# Data Transformation from Temporary Table, which add some more column to Real Table we will use for query
INSERT INTO Publication (
  SELECT DISTINCT TP.PubID,
    TP.PubKey,
    TP.PubType,
    TP.MDate,
    TF1.Value,
    TF2.Value
  FROM TempPublication as TP, TempField as TF1, TempField as TF2
  WHERE TP.PubKey = TF1.PubKey AND TP.PubKey = TF2.PubKey AND
        TF1.FieldName = 'title' AND TF2.FieldName = 'year'
);

# Create Sub-Class Table : Article, Book, Inproceedings, Proceeding, ...
