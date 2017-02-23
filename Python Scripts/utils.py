# various functions for KMeans clustering
# packages
import numpy as np
import cv2
import pickle

# takes the output list from KMeans
def make_hist(clt):

    clusters = clt.cluster_centers_
    labels = clt.labels_
    numLabels = np.arange(0, len(np.unique(labels)) + 1)
    (hist, _) = np.histogram(clt.labels_, bins = numLabels)
    hist = hist.astype("float")
    hist /= hist.sum()

    return zip(hist, clusters)

# this just plots a bar with sections colored according to computed color clusters & fractions corresponding to fraction of pixels assigned to that color - i.e., the bottom half of the plots we're producing
def plot_colors(zippy):
    bar = np.zeros((50, 300, 3), dtype = "uint8")
    startX = 0

    # loop over pct of each cluster and color of cluster
    for (percent, color) in zippy:
        endX = startX + (percent * 300)
        cv2.rectangle(bar, (int(startX), 0), (int(endX), 50), color.astype("uint8").tolist(), -1)
        startX = endX

    # return the bar chart
    return bar

    # now we can plot it!

# flattens a list
def flatten(bigList):
    newList = [item for sublist in bigList for item in sublist]
    return(newList)

def pickleLoader(pklFile):
    try:
        while True:
            yield pickle.load(pklFile)
    except EOFError:
        pass
