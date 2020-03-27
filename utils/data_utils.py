import os
import numpy as np
import pandas as pd
import csv

from pathlib import Path

file = Path(__file__)
ROOT_PATH = file.parent.parent
DATA_PATH = ROOT_PATH.joinpath("data")

class DataLoader():

    def __init__(self):
        data = self.read_file()


    def read_file(self):
        '''
        Reading in the .csv datafiles and concatenate them together in one dataframe.
        :returns concatenated datafiles (.csv) as a pandas dataframe.
        '''
        counter = 0

        for file in os.listdir(DATA_PATH):
            filename = os.fsdecode(file)
            if filename.endswith(".csv"):
                counter += 1
                df = pd.read_csv(os.path.join(DATA_PATH, filename))

                if counter == 1:
                    df_complete = df
                    continue

                frames = [df_complete, df]
                df_complete = pd.concat(frames)

            else:
                print("Error encountered while parsing file: ", filename)

        print(df_complete.head(20))
        print(df_complete.shape)

        return (df_complete)


dl = DataLoader()
