import os
import numpy as np
import pandas as pd
import sys

# Print the whole numpy array
np.set_printoptions(threshold=sys.maxsize)

from utils.data_utils import *
from utils.vis_utils import *
from utils.model import *


if __name__ == "__main__":
    # Instantiate the dataloader object.
    dl = DataLoader()

    # prepare the dataframe for further actions.
    data = dl.read_file()
    data = dl.drop_nth_row(data, nth_row=5)
    x = dl.convert_to_np(data)

    print(x.shape)

    cf = ClusteringFrame()
    k = 100
    centroids, clustering = cf.kmeans(x, k, iterations=20)

    print(centroids)

    #visualize_dataframe(data)
