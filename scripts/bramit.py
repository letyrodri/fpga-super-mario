import sys

filename = sys.argv[1]

f = open(filename, "rb")
f2 = open(filename+".out","wrb")

try:
    byte = f.read(1)
    while byte != "":
        byteStr = "{0:b}".format(ord(byte)).rjust(8,'0')
        f2.write(byteStr)
        byte = f.read(1)
finally:
    f.close()
    f2.close()
