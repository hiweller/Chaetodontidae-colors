import numpy as np
import cv2
import os
from sklearn.cluster import KMeans
import pickle

os.chdir('/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Code/Python Scripts')
img = '../../Test/chpau_01.jpg'

output = '/Users/hannah/Dropbox/Colorful_Fishinator/OutTest'

image = cv2.imread(img)

image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

image = image.reshape((image.shape[0] * image.shape[1], 3))

bg_col = np.array([0, 255, 1])

image = image[np.all(image != bg_col, axis=1)]
image = image[np.logical_not(np.logical_and(image[:,0]<45, image[:,1]>180, image[:,2]<50))]

clt = KMeans(n_clusters = 4)

clt.fit(image)

with open(output+'/pickleTest.pkl', 'wb') as out:
    pickle.dump(clt, out)

del clt

with open(output+'/pickleTest.pkl', 'rb') as input:
    clt = pickle.load(input)

labels = clt.labels_
clusters = clt.cluster_centers_
inertia = clt.inertia_

test = []

for c in np.unique(clt.labels_):
    pix = image[clt.labels_==c]
    test.append([np.linalg.norm(pix[i]-clt.cluster_centers_[c]) for i in pix])

# distances = []
#
# for i in range(image.shape[0]):
#     label = clt.labels_[i]
#     distances.append(np.linalg.norm(image[i]-clt.cluster_centers_[label]))
#
# meanDist = np.mean(distances)
