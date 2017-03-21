"""REQUIRED:
- openCV
- Python 2.7+
- Matplotlib
- sklearn"""

# import necessary packages
from sklearn.cluster import KMeans
import matplotlib.pyplot as plt
import argparse
import utils
from collections import Iterable
from itertools import chain
from sklearn.utils import shuffle
import cv2
import time
import numpy as np

# use KMeans clustering to find mean color clusters
# takes 2 arguments: image in question (jpg or png both tested) & number of clusters you want to compute
def color_extract(img, clusters):
    image = cv2.imread(img) # read in raw image (BGR)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
    bg_col = np.array([0, 255, 1], dtype = 'uint8') # set BG

    fig, (ax1, ax2) = plt.subplots(2, 1) # generate figure with top panel (original image) and bottom panel (histogram)

    im1 = ax1.imshow(image) # store original image on top
    plt.axis("off")

    # reshape into pixel matrix
    image = image.reshape((image.shape[0] * image.shape[1], 3))

    # delete all the bright green pixels
    image = image[np.all(image != bg_col, axis=1)]
    image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]

    # cluster pixel colors using kmeans algorithm
    clt = KMeans(n_clusters = clusters)
    clt.fit(image)

    zippy = utils.make_hist(clt)

    distances = []

    for i in range(image.shape[0]):
        label = clt.labels_[i]
        distances.append(np.linalg.norm(image[i]-clt.cluster_centers_[label]))

    meanDist = np.mean(distances)


    # NOTE: I SUPER FORGOT TO WRITE THIS PART BEFORE TRYING TO RUN THE CODE AND BANGED MY HEAD AGAINST THE WALL FOR LIKE AN HOUR TRYING TO FIX THIS!! WHAT A FOOL I AM
    # makes the bar plot + adds it to the bottom of our saved image
    bar = utils.plot_colors(zippy)
    im2 = ax2.imshow(bar)

    plt.axis("off")
    # zippy = sorted(zippy, reverse = True)
    zippy = [i for j in zippy for i in j]
    zippy = [i for j in zippy for i in j.flatten('F')]
    zippy = [meanDist] + zippy
    zippy = [clt.inertia_] + zippy
    zippy.insert(0, img[0:len(img)-4])

    return zippy

    # return clt

def color_extract_sample(img, clusters):
    image = cv2.imread(img) # read in raw image (BGR)
    image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
    bg_col = np.array([0, 255, 1], dtype = 'uint8') # set BG

    fig, (ax1, ax2) = plt.subplots(2, 1) # generate figure with top panel (original image) and bottom panel (histogram)

    im1 = ax1.imshow(image) # store original image on top
    plt.axis("off")

    # reshape into pixel matrix
    image = image.reshape((image.shape[0] * image.shape[1], 3))

    # delete all the bright green pixels
    image = image[np.all(image != bg_col, axis=1)]
    image = image[np.logical_not(np.logical_and(image[:,0]<120, image[:,1]>150, image[:,2]<120))]

    # sample 10,000 random pixels for fitting
    image = shuffle(image, random_state=0)[:10000]

    clt = KMeans(n_clusters = clusters)
    clt.fit(image)

    zippy = utils.make_hist(clt)

    distances = []

    for i in range(image.shape[0]):
        label = clt.labels_[i]
        distances.append(np.linalg.norm(image[i]-clt.cluster_centers_[label]))

    meanDist = np.mean(distances)

    # makes the bar plot + adds it to the bottom of our saved image
    bar = utils.plot_colors(zippy)
    im2 = ax2.imshow(bar)

    plt.axis("off")
    zippy = [i for j in zippy for i in j]
    zippy = [i for j in zippy for i in j.flatten('F')]
    zippy = [meanDist] + zippy
    zippy = [clt.inertia_] + zippy
    zippy.insert(0, img[0:len(img)-4])

    return zippy

    # return clt
