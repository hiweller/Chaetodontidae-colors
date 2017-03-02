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
import pickle
import os
import numpy as np

"""
NEXT STEPS:
- load clt fits from pickled files
- get measure of each cluster's spread
- get avg of measurements? (gets around weighting problem - getting overall average will weight larger clusters higher because they have more pixels, so improvements for smaller features won't end up ranking)
"""

os.chdir('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/Python Scripts')
output = '/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/ClusterPickles/'
pickleDir = glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/ClusterPickles/*Generator.pkl')
imDir = glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Images/*.jpg')
imDir.extend(glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Images/*.png'))

bg_col = np.array([0, 255, 1])

for gen in pickleDir[0:2]:

    i = 0
    pixDist = []
    with open(gen, 'r') as f:

        for clt in utils.pickleLoader(f):

            image = imDir[i]

            image = cv2.imread(image) # read in raw image (BGR)
            image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
            # bg_col = np.array([0, 255, 1], dtype = 'uint8')

            # reshape into pixel matrix
            image = image.reshape((image.shape[0] * image.shape[1], 3))

            # delete all the bright green pixels
            image = image[np.all(image != bg_col, axis=1)]
            image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]

            distances = []

            for c in np.unique(clt.labels_):
                pix = image[clt.labels_==c]
                distances.append([np.linalg.norm(j-clt.cluster_centers_[c]) for j in pix])

                # tempDist = []
                # for j in pix:
                #     tempDist.append(np.linalg.norm(j-clt.cluster_centers_[c]))
                #
                # distances.append(tempDist)
                # distances.append([np.linalg.norm(pix[j]-clt.cluster_centers_[c]) for j in pix])


            # print [np.mean(n) for n in distances]
            print i
            i = i + 1

            pixDist.append(distances)

        pixMeans = []

        for el in pixDist:
            pixMeans.append([np.mean(n) for n in el])

        zippy = zip(imDir, [np.mean(n) for n in pixMeans])

        header = ['ID', 'Avg. Cluster Spread']
        #
        # for i in range(len(pixDist[0])):
        #     header.append('Cluster' + str(i+1) + ' Spread')


        outCSV = output+gen.split('/')[-1][0:2]+'ClusterSpread.csv'
        with open(outCSV, 'wb') as f:
            writer = csv.writer(f)
            writer.writerow(header)
            writer.writerows(zippy)



# test = open('../../ClusterPickles/01Generator.pkl', 'r')
# test1 = pickle.load(test) # generator object
# for item in pickleDir:
#
#     bigList = pickle.load(open(item, 'r'))
#
#     f = open('../../ClusterPickles/'+item.split('/')[-1][0:2]+'Generator.pkl', 'wb')
#
#     for l in bigList:
#         pickle.dump(l, f)

output = '/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/ClusterPickles/'

pickleDir = glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/ClusterPickles/*Generator.pkl')
imDir = glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Images/*.jpg')
imDir.extend(glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Images/*.png'))

bg_col = np.array([0, 255, 1])

gen = pickleDir[0]
# i = 0
# pixDist = []
# with open(gen, 'r') as f:
#
#     for clt in utils.pickleLoader(f):
#
#         image = imDir[i]
#
#         image = cv2.imread(image) # read in raw image (BGR)
#         image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
#         # bg_col = np.array([0, 255, 1], dtype = 'uint8')
#
#         # reshape into pixel matrix
#         image = image.reshape((image.shape[0] * image.shape[1], 3))
#
#         # delete all the bright green pixels
#         image = image[np.all(image != bg_col, axis=1)]
#         image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]
#
#         distances = []
#
#         for c in np.unique(clt.labels_):
#             pix = image[clt.labels_==c]
#             distances.append([np.linalg.norm(pix[j]-clt.cluster_centers_[c]) for j in pix])
#
#
#         # print [np.mean(n) for n in distances]
#
#         i = i + 1
#
#         pixDist.append(distances)
#
#     pixMeans = []
#
#     for el in pixDist:
#         pixMeans.append([np.mean(n) for n in el])
#
#     pixMeans = [i for j in pixMeans for i in j]
#
#     zippy = zip(imDir, pixMeans, pixDist)
#
#     header = ['ID', 'Avg. Cluster Spread']
#
#     for i in range(len(pixDist[0])):
#         header.append('Cluster' + str(i+1) + ' Spread')
#
#
#     outCSV = output+item.split('/')[-1][0:2]+'ClusterSpread.csv'
#     with open(outCSV, 'wb') as f:
#         writer = csv.writer(f)
#         writer.writerow(header)
#         writer.writerows(zippy)
# 
# for gen in pickleDir:
#
#     i = 0
#     pixDist = []
#     with open(gen, 'r') as f:
#
#         for clt in utils.pickleLoader(f):
#
#             image = imDir[i]
#
#             image = cv2.imread(image) # read in raw image (BGR)
#             image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
#             # bg_col = np.array([0, 255, 1], dtype = 'uint8')
#
#             # reshape into pixel matrix
#             image = image.reshape((image.shape[0] * image.shape[1], 3))
#
#             # delete all the bright green pixels
#             image = image[np.all(image != bg_col, axis=1)]
#             image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]
#
#             distances = []
#
#             for c in np.unique(clt.labels_):
#                 pix = image[clt.labels_==c]
#                 distances.append([np.linalg.norm(pix[j]-clt.cluster_centers_[c]) for j in pix])
#
#
#             # print [np.mean(n) for n in distances]
#
#             i = i + 1
#
#             pixDist.append(distances)
#
#         pixMeans = []
#
#         for el in pixDist:
#             pixMeans.append([np.mean(n) for n in el])
#
#         pixMeans = [i for j in pixMeans for i in j]
#
#         zippy = zip(imDir, pixMeans, pixDist)
#
#         header = ['ID', 'Avg. Cluster Spread']
#
#         for i in range(len(pixDist[0])):
#             header.append('Cluster' + str(i+1) + ' Spread')
#
#
#         outCSV = output+item.split('/')[-1][0:2]+'ClusterSpread.csv'
#         with open(outCSV, 'wb') as f:
#             writer = csv.writer(f)
#             writer.writerow(header)
#             writer.writerows(zippy)
#


# test = open('../../ClusterPickles/01Generator.pkl', 'r')
# test1 = pickle.load(test) # generator object
# for item in pickleDir:
#
#     bigList = pickle.load(open(item, 'r'))
#
#     f = open('../../ClusterPickles/'+item.split('/')[-1][0:2]+'Generator.pkl', 'wb')
#
#     for l in bigList:
#         pickle.dump(l, f)




# imDir = glob.glob('../../Images/*.jpg')
# imDir.extend(glob.glob('../../Images/*.png'))
#
# i = 0
#
# color1 = pickle.load(open(pickleDir[0], 'rb'))



>>>>>>> 5b40e7951318a7a827b48fc25d38d2a98aeeb0ff
#
#

#
# for i in range(len(test)):
#
#     image = imDir[i]
#     clt = test[i]
#
#     image = cv2.imread(image) # read in raw image (BGR)
#     image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB) # convert to RGB
#     # bg_col = np.array([0, 255, 1], dtype = 'uint8')
#
#     # reshape into pixel matrix
#     image = image.reshape((image.shape[0] * image.shape[1], 3))
#
#     # delete all the bright green pixels
#     image = image[np.all(image != bg_col, axis=1)]
#     image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]
#
#     distances = []
#
#     for c in np.unique(clt.labels_):
#         pix = image[clt.labels_==c]
#         distances.append([np.linalg.norm(pix[i]-clt.cluster_centers_[c]) for i in pix])
#
#     print np.mean(distances)
#
#
# clt = pickle.load(open(pickleDir[0], 'rb'))

# for file in pickleDir:
#     with open(file, 'rb') as input:
#         clt = pickle.load(input)
#
#
















# # read images from folder
# imageDir =  glob.glob('../Test/*.jpg')
# c = 1
# batchname = 'ColorTest'
# output = '../OutTest/'
# outcsv = output + 'out.csv'
# zippy = []

# NOTE: edit this savename feature - right now it assumes that "folder" arg is passed with either as complete filepath or with nothing in front of it
# maybe do what spiderFish does - get full filepath from relative one and use that for all output specifications?
#
# if batchname != None:
#     batch = batchname + ".png"
# else:
#     batch = "_" + str(c) + "Clusters.png"
#
#
# for i in range(len(imageDir)):
#     splitname = str.split(imageDir[i], '/')[2]
#     savename = splitname[0:len(splitname)-4]
#     new = ce.color_extract(imageDir[i], c)
#     zippy.append(new)
#     plt.savefig(output + savename + batch)
#     plt.close("all")
#
# num = c
# colnames = ['Percent', 'R', 'G', 'B']
# header = ['ID', 'Inertia']
#
# for i in range(num):
#     for j in range(len(colnames)):
#         header.append(colnames[j] + str(i+1))
#
#
# with open(outcsv, 'wb') as f:
#     writer = csv.writer(f)
#     writer.writerow(header)
#     writer.writerows(zippy)
