import os
import numpy as np
import pandas as pd

from utils.data_utils import *
from utils.vis_utils import *
from utils.model import *


if __name__ == "__main__":
    dl = DataLoader()
    data = dl.read_file()

    x = dl.convert_to_np(data)

    cf = ClusteringFrame()
    k = 100
    centroids, clustering = cf.kmeans(x, k, iterations=20)

    #visualize_dataframe(data)
