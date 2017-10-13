import os


#PUB_TYPE = ["article", "inproceedings", "proceedings", "book",
#            "incollection", "phdthesis", "masterthesis", "www", "data"]

PUB_TYPE = ["article", "inproceedings", "proceedings"]

#FIELD_TYPE = ["author", "editor", "title", "booktitle", "pages", "year", "address", "journal",
#              "volume", "number", "month", "url", "ee", "cdrom", "cite", "publisher", "note",
#              "crossref", "isbn", "series", "school", "chapter", "publnr"]

FIELD_TYPE = ["author", "title", "year", "journal", "month", "crossref"]


FIELD_TERMINATOR = "|"


BASEDIR = os.path.dirname(os.path.abspath(__file__))
