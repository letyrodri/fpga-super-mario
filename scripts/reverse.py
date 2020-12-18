import sys

f = open(sys.argv[1], "r");
f2 = open(sys.argv[2], "w");

s=f.read(8);
while (s != ''):
	x = s[6:8]+s[0:3]+s[3:6];
	print x
	f2.write(x+'\n');
	s = f.read(8);
f.close()
f2.close()
