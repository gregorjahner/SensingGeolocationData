import os
import numpy as np
import pandas as pd

from utils.data_utils import *
from utils.vis_utils import *


if __name__ == "__main__":
    dl = DataLoader()
    data = dl.read_file()

    visualize_dataframe(data)
