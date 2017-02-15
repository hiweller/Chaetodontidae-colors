import numpy as np
import cv2
import os
from sklearn.cluster import KMeans

os.chdir('/Users/hannah/Dropbox/Colorful Fishinator/Python Scripts')
img = '../Test/chpau_01.jpg'

image = cv2.imread(img)

image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

image = image.reshape((image.shape[0] * image.shape[1], 3))

bg_col = np.array([0, 255, 1])

image = image[np.all(image != bg_col, axis=1)]

clt = KMeans(n_clusters = 4)

clt.fit(image)

labels = clt.labels_
clusters = clt.cluster_centers_
inertia = clt.inertia_
