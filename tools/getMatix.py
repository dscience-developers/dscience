#!/usr/bin/python
#-*- coding: utf-8 -*-

# Tools to get all matrix from ftp://ftp.ncbi.nih.gov/blast/matrices/
# and integrate in DScience code source.

from ftplib import FTP
import re

# Configuration
url = "ftp://ftp.ncbi.nih.gov"
path = "blast/matrices/"
dirstock = "matrix/"
files = []
output = "matrixD"
matrix_list = [ "DAYHOFF",
                "GONNET",
                "IDENTITY" ]

def cleanLine(l):
    new = []
    for i in l:
        i = i.rstrip()
        if i != '' and i != ' ' and i:
            new.append(i)
    return new

# Download all files
print "Connecting to " + url + "."
ftp = FTP('ftp.ncbi.nih.gov')
print "Login processing."
ftp.login()
print "Retrieve files list."
ftp.cwd(path)
files_tmp = ftp.nlst()

for f in files_tmp:
    if "BLOSUM" in f or "PAM" in f or f in matrix_list:
        files.append(f)

for n in files:
    print "Downloading " + n + "."
    f = open(dirstock+n, 'wb')
    ftp.retrbinary('RETR '+n, f.write)
    f.close()

ftp.close()
print "All files downloaded."

# Parse each file 
f = open(output, 'w')

n = files[0]
for n in files:
    print " * " + n,
    t = open(dirstock+n, 'rb')

    matrix = []
    for l in t:
        if l[0] != '#':
            line = cleanLine(l.split(' '))
            if line[:-1] == '\n':
                matrix.append(cleanLine(l.split(' '))[:-1])
            else:
                matrix.append(cleanLine(l.split(' ')))

    # Some darks tricks :-)
    new_m = []
    tmp = sorted(matrix[0])
    tmp.append('*')
    tmp.insert(0,'')

    matrix[0].append('*')
    matrix[0].insert(0,'')

    new_m.append(tmp)

    for x in new_m[0][1:]:
        line = []
        line.append(x)
        for y in new_m[0][1:]:
            ix = matrix[0].index(x)
            iy = matrix[0].index(y)
            line.append(matrix[ix][iy])
            
        new_m.append(line)
    
    # Print code in the file

    f.write("\n    case \""+n+"\":\n")
    f.write("    matrix = [\n")

    i=0
    for l in new_m[1:]:
        f.write("        [")
        f.write(', '.join(l[1:]))
        f.write("]")
        if i+1 != len(new_m[1:]):
            f.write(",\n")
        else:
            f.write("];\n")
        i+=1

    f.write("   break;\n")
    print " Done."
f.close()

print " *** Code has been writed in " + output + " *** "
