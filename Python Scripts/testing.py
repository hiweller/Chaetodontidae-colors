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
from sklearn.utils import shuffle

os.chdir('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/Python Scripts')
imDir = glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/GoodQualityImages/*.jpg')
imDir.extend(glob.glob('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/GoodQualityImages/*.png'))

bg_col = np.array([0, 255, 1])

output = '/Users/hannah/Dropbox/Colorful_Fishinator/OutTest'

image = cv2.imread(imDir[0])

image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

image = image.reshape((image.shape[0] * image.shape[1], 3))

bg_col = np.array([0, 255, 1])

image = image[np.all(image != bg_col, axis=1)]
image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]

image_array_sample = shuffle(image, random_state=0)[:1000]

clt = KMeans(n_clusters = 4)

clt.fit(image)








# i = 0
# pixDist = []
# gen = pickleDir[0]
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
#             # tempDist = []
#             distances.append([np.linalg.norm(j-clt.cluster_centers_[c]) for j in pix])
#
#         # print [np.mean(n) for n in distances]
#         print i
#         i = i + 1
#
#         pixDist.append(distances)
#
#     pixMeans = []
#
#     for el in pixDist:
#         pixMeans.append([np.mean(n) for n in el])
#
#     zippy = zip(imDir, [np.mean(n) for n in pixMeans])
#
#     header = ['ID', 'Avg. Cluster Spread']
#         #
#         # for i in range(len(pixDist[0])):
#         #     header.append('Cluster' + str(i+1) + ' Spread')
#
#
#
#



# output = '/Users/hannah/Dropbox/Colorful_Fishinator/OutTest'
#
# image = cv2.imread(img)
#
# image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)
#
# image = image.reshape((image.shape[0] * image.shape[1], 3))
#
# bg_col = np.array([0, 255, 1])
#
# image = image[np.all(image != bg_col, axis=1)]
# image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]
#
# clt = KMeans(n_clusters = 4)
#
# clt.fit(image)
#
# with open(output+'/pickleTest.pkl', 'wb') as out:
#     pickle.dump(clt, out)
#
# del clt
#
# with open(output+'/pickleTest.pkl', 'rb') as input:
#     clt = pickle.load(input)
#
# labels = clt.labels_
# clusters = clt.cluster_centers_
# inertia = clt.inertia_
#
# test = []
#
# for c in np.unique(clt.labels_):
#     pix = image[clt.labels_==c]
#     test.append([np.linalg.norm(pix[i]-clt.cluster_centers_[c]) for i in pix])


# labels = clt.labels_
# clusters = clt.cluster_centers_
# inertia = clt.inertia_
#
# test = []
#
# for c in np.unique(clt.labels_):
#     pix = image[clt.labels_==c]
#     test.append([np.linalg.norm(pix[i]-clt.cluster_centers_[c]) for i in pix])

# distances = []
#
# for i in range(image.shape[0]):
#     label = clt.labels_[i]
#     distances.append(np.linalg.norm(image[i]-clt.cluster_centers_[label]))
#
# meanDist = np.mean(distances)
