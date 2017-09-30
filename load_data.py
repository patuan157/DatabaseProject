from xml.sax import make_parser
from xml.sax.handler import ContentHandler
import time
from constant import *


class DBHandler(ContentHandler):
    def __init__(self):
        self.content = None
        self.att = None
        self.parent_key = None
        self.has_char = False
        pass

    def startDocument(self):
        # Write Data Field into Temporary Data File
        with open(os.path.join(BASEDIR, "tmpData", "pubFile.csv"), "w+") as f:
            f.write("PubKey||MDate||PubType\n")

        with open(os.path.join(BASEDIR, "tmpData", "fieldFile.csv"), "w+") as f:
            f.write("FieldName||PubKey||Value\n")

    def startElement(self, name, attrs):
        if name in PUB_TYPE:         # Publication Tag
            self.att = attrs
            self.parent_key = self.att.get("key")
        elif name in FIELD_TYPE:  # Field Tag : title, author, pages, year, journal
            self.has_char = True

    def endElement(self, name):
        if name in PUB_TYPE:         # Publication Tag
            output = ""
            if "key" in self.att.keys():            # Every Publication Should have a Key
                output += str(self.att.get("key")) + FIELD_TERMINATOR
            else:
                output += FIELD_TERMINATOR

            if "mdate" in self.att.keys():
                output += str(self.att.get("mdate")) + FIELD_TERMINATOR
            else:
                output += FIELD_TERMINATOR

            output += name                     # The Publication Type at the end of the records

            # 3 Attributes we care for Publication : Pub_Key||Mdate||Pub_type\n. Other is not-necessary
            with open(os.path.join(BASEDIR, "tmpData", "pubFile.csv"), "a") as f:
                f.write(output + "\n")

        elif name in FIELD_TYPE:
            output = name + FIELD_TERMINATOR + str(self.parent_key) \
                        + FIELD_TERMINATOR + str(self.content)

            # 3 Attributes we care for Field : FieldName||Pub_Key||Value\n
            with open(os.path.join(BASEDIR, "tmpData", "fieldFile.csv"), "a") as f:
                f.write(output + "\n")

    def characters(self, content):
        if self.has_char:
            self.content = content
        else:
            self.content = None
        self.has_char = False

    def endDocument(self):
        pass


start = time.time()

parser = make_parser()
parser.setContentHandler(DBHandler())
data_file = os.path.join(BASEDIR, "data", "sample.xml")
parser.parse(open(data_file))

print("Parsing Time")
print(time.time() - start)

