import os


PUB_TYPE = ["article", "inproceedings", "proceeding", "book",
            "incollection", "phdthesis", "masterthesis", "www", "data"]

FIELD_TYPE = ["author", "editor", "title", "booktitle", "pages", "year", "address", "journal",
              "volume", "number", "month", "url", "ee", "cdrom", "cite", "publisher", "note",
              "crossref", "isbn", "series", "school", "chapter", "publnr"]

FIELD_TERMINATOR = "||"


BASEDIR = os.path.dirname(os.path.abspath(__file__))
