import sys
import csv
filename = sys.argv[1]


try:
    with open(filename, 'r') as csvfile:
        reader = csv.reader(csvfile, delimiter=',')
        i = 0
        rows = []
        for row in reader:
            if i == 0:
                rows = []
                for j in range(0,20):
                    rows.append([])

            for j in range(0,20):
                byteStr = "{0:b}".format(int(row[j])).rjust(5,'0')
                rows[j].append(byteStr)
            i = i+1;

    print rows[0]
    print rows[14]


    with open(filename+'.out', 'wb') as f:
        s = 0
        while(len(rows[0]) > s):
            for i in range(0,20):
                f.write('\n'.join(rows[i][s+0:s+15]))
                f.write('\n')

            s = s+15
finally:
    pass
