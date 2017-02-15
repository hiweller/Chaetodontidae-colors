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
- switch to absolute instead of relative filepaths
- more effective greenscreening: instead of removing green cluster, remove all green pixels from the start and reshape remaining non-green pixels into p x 3 matrix (p = number of non-green pixels) for KMeans
"""

# construct argument parser so we don't have to launch python to run the script (makes bash pipelining much easier!)

# ex: $ python fish_loops.py -f Test/ -c 1 -b _1Cluster
ap = argparse.ArgumentParser()
ap.add_argument("-f", "--folder", required = True, help = "Path to folder of images (takes JPG and PNG)")
ap.add_argument("-c", "--clusters", required = True, type = int, help = "Number of clusters for KMeans sorting")
ap.add_argument("-b", "--batchname", required = False, help = "Optional identifier that will be pasted onto the end of the output files; defaults to _#Clusters")
ap.add_argument("-o", "--output", required = True, help = "Folder for putting output images and out.csv file with color cluster and percentage information")
args = vars(ap.parse_args())

# read images from folder
# NOTE: when not on an airplane, look up regex for "or" to just get JPGs & PNGs in one line instead of this embarrassing way
# FOLLOWUP NOTE: turns out you can't do that with glob so we're doing it this way now.
imageDir = glob.glob(args["folder"] + '*.jpg')
imageDir.extend(glob.glob(args["folder"] + '*.png'))
zippy = []
c = args["clusters"]


# NOTE: edit this savename feature - right now it assumes that "folder" arg is passed with either complete filepath or with nothing in front of it
# maybe do what spiderFish does - get full filepath from relative one and use that for all output specifications?
#
if args["batchname"] != None:
    batch = str(args["batchname"]) + ".png"
else:
    batch = "_" + str(c) + "Clusters.png"

for i in range(len(imageDir)):
    splitname = str.split(imageDir[i], '/')[-1]
    savename = splitname[0:len(splitname)-4]
    new = ce.color_extract(imageDir[i], c)
    zippy.append(new)
    plt.savefig(args["output"] + savename + batch)
    plt.close("all")

num = c
colnames = ['Percent', 'R', 'G', 'B']
header = ['ID', 'Sum of Residuals']

for i in range(num):
    for j in range(len(colnames)):
        header.append(colnames[j] + str(i+1))


outCSV = args["output"]+'out.csv'
with open(outCSV, 'wb') as f:
    writer = csv.writer(f)
    writer.writerow(header)
    writer.writerows(zippy)
