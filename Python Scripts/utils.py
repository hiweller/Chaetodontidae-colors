# various functions for KMeans clustering
# packages
import numpy as np
import cv2

# takes the output list from KMeans
def remove_bg(clt):

    labels = clt.labels_
    clusters = np.array(clt.cluster_centers_)
    inertia = clt.inertia_
    # bg_col = np.array([0, 255, 0])

    # diffs = abs(clusters - bg_col)
    # sumDiffs = [sum(diffs[i]) for i in range(len(clusters))]

    # idx = sumDiffs.index(min(sumDiffs))

    # clusters = np.delete(clusters, idx, 0)

    # numLabels = np.arange(0, len(np.unique(labels)) + 1)
    numLabels = np.arange(0, len(np.unique(labels)) + 1)
    (hist, _) = np.histogram(clt.labels_, bins = numLabels)
    hist = hist.astype("float")
    # hist = np.delete(hist, idx, 0)
    hist /= hist.sum()

    return zip(hist, clusters)
# takes the output list from KMeans
# def remove_bg(clt):
#
#     base = 5 # wiggle room for cluster to eliminate
#     labels = clt.labels_ # handles (use later to delete)
#     clusters = clt.cluster_centers_ # get actual cluster values
#
#     index = [] # we'll store the identified green cluster here
#
#     for cluster in range(len(clusters)):
#         old_cluster = clusters[cluster] # go one cluster at a time
#         new_cluster = [] # cluster we're going to round
#
#         for i in np.nditer(old_cluster):
#             # round the cluster to the nearest 5 (so something like [0.1, 246.8, 0.9] becomes [0, 255, 0])
#             new_cluster.append(int(base * round(float(i)/base)))
#
#
#         # ok new game plan: whichever cluster is CLOSEST to [0, 255, 0] gets zapped
#         if new_cluster == [0, 255, 0]: # if rounded cluster is identical to our preset background...
#             index.append(cluster) # TARGET FOR DEATH!!
#
#     # from the clusters we got from KMeans function, delete the cluster means we just identified as being very close to [0, 255, 0]
#     clusters = np.delete(clusters, index, 0)
#
#     numLabels = np.arange(0, len(np.unique(labels)) + 1)
#     (hist, _) = np.histogram(clt.labels_, bins = numLabels)
#     hist = hist.astype("float")
#     hist = np.delete(hist, index, 0)
#     hist /= hist.sum()
#
#     return zip(hist, clusters)
#
#

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





    #
    #     # ok new game plan: whichever cluster is CLOSEST to [0, 255, 0] gets zapped
    #     if new_cluster == [0, 255, 0]: # if rounded cluster is identical to our preset background...
    #         index.append(cluster) # TARGET FOR DEATH!!
    #
    # # from the clusters we got from KMeans function, delete the cluster means we just identified as being very close to [0, 255, 0]
    # clusters = np.delete(clusters, index, 0)
    #
    # numLabels = np.arange(0, len(np.unique(labels)) + 1)
    # (hist, _) = np.histogram(clt.labels_, bins = numLabels)
    # hist = hist.astype("float")
    # hist = np.delete(hist, index, 0)
    # hist /= hist.sum()
    #
    # return zip(hist, clusters)
