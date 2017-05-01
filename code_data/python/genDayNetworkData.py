##### not used 
##### load data with jupyter notebook
#####
import csv
import datetime
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import numpy as np
import datetime as dt

def readData(dataSrcs):
    print(dataSrcs)
    i = 0
    for src in dataSrcs:
        with open('Data/'+src+'.ignore', 'r') as csvfile:
            reader = csv.reader(csvfile, delimiter='\t')
            for row in reader:
                print(row[10])
    pass



# 6 keywork + geo
# 7, 8 themes
# 9 location                    #18,19source
# 10 actor                      # 20, 21 link
# 11 people or actor
# 12 not sure
# 13 not sure
# 15 tones
# 16 ??
# camo???
if __name__ == "__main__":
    path = ['20150218230000.gkg.csv']
    data = readData(path)
