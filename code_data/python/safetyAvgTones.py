import csv
import datetime
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import numpy as np
import datetime as dt

def readData(dataSrcs):
    i = 0
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
                values.append(float(row[1])+i*10)
        datesets.append(dates)
        data.append(values)
        i = i + 1
    return [datesets, data];

def plotGraph():
    pass

if __name__ == "__main__":
    # do work
    print("Ploting time line...")
    
    # globals
    dataSrcs = list();

    dataSrcs.append('safety_crisys_disaster.csv')
    dataSrcs.append('france_safety.csv')
    dataSrcs.append('germany_safety.csv')


    [datesets, data] = readData(dataSrcs)

    for i in range(0, len(data)):
        print(len(datesets[i]), " ", len(data[i]))

    plt.gca().xaxis.set_major_formatter(mdates.DateFormatter('%m/%d/%Y'))
    plt.gca().xaxis.set_major_locator(mdates.MonthLocator())
    plt.gca().set_ylabel('Avg. Tone')
    uk, = plt.plot(datesets[0], data[0], label='UK Safety')
    fr, = plt.plot(datesets[1], data[1], label='FR Safety')
    de, = plt.plot(datesets[2], data[2], label='DE Safety')
    handles=[uk, fr, de]
    plt.legend(handles)
    plt.gcf().autofmt_xdate()
    plt.show()
