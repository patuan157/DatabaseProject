import time
import sys
import codecs
import html
import re
from datetime import datetime

from xml.sax import make_parser
from xml.sax.handler import ContentHandler
from constant import *


class DBHandler(ContentHandler):
    def __init__(self):
        self.content = '' 
        self.count_pub = 0
        self.att = None
        self.parent_key = None
        self.parent_title = ''
        self.parent_noAuthors = 0
        pass

    def startDocument(self):
        # Create tmpData folder if not exist
        if not os.path.exists(os.path.join(BASEDIR, "tmpData")):
            os.makedirs(os.path.join(BASEDIR, "tmpData"))

        # Write Data Field into Temporary Data File
        with codecs.open(os.path.join(BASEDIR, "tmpData", "pubFile.csv"), "w+", encoding="utf-8") as f:
            f.write("PubKey|MDate|PubType\n")

        with codecs.open(os.path.join(BASEDIR, "tmpData", "fieldFile.csv"), "w+", encoding="utf-8") as f:
            f.write("FieldName|PubKey|Value\n")

    def startElement(self, name, attrs):
        if name in PUB_TYPE:         # Publication Tag
            self.att = attrs
            self.parent_key = self.att.get("key")
            self.parent_noAuthors = 0
            self.parent_title = ''
            self.count_pub += 1
        elif name in FIELD_TYPE:  # Field Tag : title, author, pages, year, journal
            self.content = ''

    def endElement(self, name):
        if name in PUB_TYPE:         # Publication Tag
            output = ""
            if "key" in self.att.keys():            # Every Publication Should have a Key
                output += str(self.att.get("key")) + FIELD_TERMINATOR
            output += str(self.parent_title) + FIELD_TERMINATOR

            if "mdate" in self.att.keys():
                mdate = str(self.att.get('mdate'))
                dt = datetime.strptime(mdate, '%Y-%m-%d')
                year = dt.year
                decade = get_decade(year)
                output += str(year) + FIELD_TERMINATOR
                output += decade + FIELD_TERMINATOR

            output += str(self.att.get('key').split('/')[1]) + FIELD_TERMINATOR

            output += str(self.parent_noAuthors)

            # 3 Attributes we care for Publication : Pub_Key|Mdate|Pub_type\n. Other is not-necessary
            with codecs.open(os.path.join(BASEDIR, "tmpData", "pubFile.csv"), "a", encoding="utf-8") as f:
                f.write(output + "\n")

        elif name in FIELD_TYPE:
            if name == 'title':
                self.parent_title = self.content
            elif name == 'author':
                self.parent_noAuthors += 1

            output = name + FIELD_TERMINATOR + str(self.parent_key) \
                        + FIELD_TERMINATOR
            if self.content != None:
                if name == 'author':
                    if (bool(re.search(r'\d', self.content))):
                        self.content = ''.join([i for i in self.content if not i.isdigit()]).strip()
                    output = output + '/'.join(self.content.rsplit(' ', 1))
                else:
                    output = output + str(self.content)

            # 3 Attributes we care for Field : FieldName|Pub_Key|Value\n
            with codecs.open(os.path.join(BASEDIR, "tmpData", "fieldFile.csv"), "a", encoding="utf-8") as f:
                f.write(output + "\n")

    def characters(self, content):
        if FIELD_TERMINATOR in content:
            content = content.replace(FIELD_TERMINATOR, ' ')
        self.content += html.unescape(content)

    def endDocument(self):
        pass

def get_decade(year):
    decade = year // 10
    result = str(decade) + '0-' + str(decade) + '9'
    return result

if __name__ == "__main__":
    start = time.time()
    if len(sys.argv) >= 1:
        fileName = sys.argv[1]
    else:
        print("Please provide the data file name to load")
        os.exit(0)
    parser = make_parser()
    parser.setContentHandler(DBHandler())
    data_file = os.path.join(BASEDIR, "data", fileName)
    with codecs.open(data_file, "r", encoding="utf-8") as f:
        parser.parse(f)
        #f.read()

    print("Parsing Time")
    print(time.time() - start)

