import argparse
import json
import sys

def processargs():
    parser = argparse.ArgumentParser();
    parser.add_argument("--name", help="name of IP group to create")
    parser.add_argument("--cidrfile", help="name of cidr list", required=True)
    parser.add_argument("--output", help="output file name", required=True)
    parser.add_argument("--update", help="create file in update format", action="store_true")
    args = parser.parse_args()
    return args


def createitems(cidrF):
    itemslist = list()

    while True:
       curritem = dict()
       curritem['type'] = 'cidr'

       cidrentry = cidrF.readline()
       cidrentry = cidrentry.rstrip()
       if not cidrentry: break
       if cidrentry.startswith('#'): continue

       curritem['value'] = cidrentry

       itemslist.append(curritem)

    return itemslist


def createfile(prefs):
    with open(prefs.output, "w") as outputF, open(prefs.cidrfile) as cidrF:
        rootjson = dict()

        if prefs.update == False:
           if prefs.name is None:
              sys.exit("If in create new ip group mode, name must be specified")
           rootjson['name'] = prefs.name

        itemslist = createitems(cidrF)

        rootjson['items'] = itemslist

        json.dump(rootjson, outputF)
        outputF.write("\n")


def main():
    prefs = processargs()
    createfile(prefs)

if __name__ == '__main__':
    main()
