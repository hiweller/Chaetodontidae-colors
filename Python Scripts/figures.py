import numpy as np
import matplotlib.pyplot as plt
from sklearn.cluster import KMeans
import cv2

n_colors = 4

image = '/Users/hannah/Dropbox/Westneat_Lab/Chaetodontidae_colors/Images/folon_02.jpg'

image = cv2.imread(image)

image = cv2.cvtColor(image, cv2.COLOR_BGR2RGB)

# image = image.reshape((image.shape[0] * image.shape[1], 3))

image = np.array(image, dtype = np.float64)/255

w, h, d = original_shape = tuple(image.shape)

assert d == 3

image_array = np.reshape(image, (w * h, d))

kmeans = KMeans(n_clusters = n_colors).fit(image_array)

labels = kmeans.predict(image_array)

def recreate_image(codebook, labels, w, h):
    """Recreate the (compressed) image from the code book & labels"""
    d = codebook.shape[1]
    image = np.zeros((w, h, d))
    label_idx = 0
    for i in range(w):
        for j in range(h):
            image[i][j] = codebook[labels[label_idx]]
            label_idx += 1
    return image

plt.figure(1)
plt.clf()
ax = plt.axes([0, 0, 1, 1])
plt.axis('off')
plt.title('Quantized image (3 colors, K-Means)')
plt.imshow(recreate_image(kmeans.cluster_centers_, labels, w, h))

plt.show()
