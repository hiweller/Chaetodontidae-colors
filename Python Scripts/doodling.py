# import the necessary packages
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import argparse
import utils
import color_binning as ce
import cv2
import time
import glob
import csv

"""
NEXT STEPS:
- fix batch naming issues
- regex for images
- provide output folder argument - if exists, put output there; if not, create it and then put it there
- switch to absolute instead of relative filepaths
- greenscreening more effectively: remove all green pixels and reshape only non-green pixels for KMeans
"""

# read images from folder
imageDir =  glob.glob('../Test/*.jpg')
c = 1
batchname = 'ColorTest'
output = '../OutTest/'
outcsv = output + 'out.csv'
zippy = []



# NOTE: edit this savename feature - right now it assumes that "folder" arg is passed with either as complete filepath or with nothing in front of it
# maybe do what spiderFish does - get full filepath from relative one and use that for all output specifications?
#
if batchname != None:
    batch = batchname + ".png"
else:
    batch = "_" + str(c) + "Clusters.png"


for i in range(len(imageDir)):
    splitname = str.split(imageDir[i], '/')[2]
    savename = splitname[0:len(splitname)-4]
    new = ce.color_extract(imageDir[i], c)
    zippy.append(new)
    plt.savefig(output + savename + batch)
    plt.close("all")

num = c
colnames = ['Percent', 'R', 'G', 'B']
header = ['ID', 'Inertia']

for i in range(num):
    for j in range(len(colnames)):
        header.append(colnames[j] + str(i+1))


with open(outcsv, 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(zippy)
