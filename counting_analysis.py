from xml.sax import make_parser
from xml.sax.handler import ContentHandler
from pprint import pprint
import time
import os
from constant import *


class DBHandler(ContentHandler):
    def __init__(self):
        self.journal = {}
        self.conf = {}
        self.pub_count = {}

    def startDocument(self):
        for name in ["article", "inproceedings", "proceeding", "book", "incollection", "phdthesis",
                    "masterthesis", "www", "data"]:
            self.pub_count[name] = 0

    def startElement(self, name, attrs):
        if name in ["article", "inproceedings", "proceeding", "book", "incollection", "phdthesis",
                    "masterthesis", "www", "data"]:
            self.process_pub(name, attrs)
            self.pub_count[name] += 1

    def process_pub(self, pub_type, attrs):
        if "journal" in attrs.get('key'):
            if pub_type not in self.journal:
                self.journal[pub_type] = 1
            else:
                self.journal[pub_type] += 1
        elif "conf" in attrs.get('key'):
            if pub_type not in self.conf:
                self.conf[pub_type] = 1
            else:
                self.conf[pub_type] += 1

    def endElement(self, name):
        pass

    def characters(self, content):
        pass

    def endDocument(self):
        pprint(self.journal)
        pprint(self.conf)
        pprint(self.pub_count)


start = time.time()
parser = make_parser()
parser.setContentHandler(DBHandler())

data_file = os.path.join(BASEDIR, "data", "dblp.xml")
parser.parse(open(data_file))

print("Parsing Time : ")
print(time.time() - start)

