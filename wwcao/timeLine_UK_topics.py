import csv
import datetime
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import numpy as np
import datetime as dt

def readData(dataSrcs):
    first = True
    data = list()
    datesets = list()
    for src in dataSrcs:
        dates = list()
        values = list()
        with open('Data/'+src, 'r') as csvfile:
            reader = csv.reader(csvfile, delimiter=',')
            for row in reader:
                dates.append(dt.datetime.strptime(row[0], '%m/%d/%Y').date())
                values.append(float(row[1]))
        datesets.append(dates)
        data.append(values)
    return [datesets, data];

def plotGraph():
    pass

if __name__ == "__main__":
    # do work
    print("Ploting time line...")
    
    # globals
    dataSrcs = list();

    dataSrcs.append('Econ.csv')
    dataSrcs.append('Government_Politics.csv')
    dataSrcs.append('safety_crisys_disaster.csv')

    [datesets, data] = readData(dataSrcs)

    for i in range(0, len(data)):
        print(len(datesets[i]), " ", len(data[i]))

    plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d/%Y'))
    plt.gca().xaxis.set_major_locator(mdates.MonthLocator())
    plt.gca().set_ylabel('Avg. Tone')
    econ, = plt.plot(datesets[0], data[0], label='Economy')
    gov, = plt.plot(datesets[1], data[1], label='Gov')
    safe, = plt.plot(datesets[2], data[2], label='safety')
    handles=[econ, gov, safe]
    plt.legend(handles)
    plt.gcf().autofmt_xdate()
    plt.show()
