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
        pass
        #data = self.read_file()


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
                df = pd.read_csv(os.path.join(DATA_PATH, filename), delimiter=',', encoding="utf-8-sig")
                df.rename(columns=lambda x: x.strip(), inplace=True)

                df = df.drop_duplicates(subset=['Timestamp'])

                if counter == 1:
                    df_complete = df
                    continue

                frames = [df_complete, df]
                df_complete = pd.concat(frames)

            else:
                print("Error encountered while parsing file: ", filename)

        print('Dataframe shape: ', df_complete.shape)
        print(df_complete.head(20))

        return (df_complete)


    def convert_to_np(self, dataframe, dimension=2):
        # Convert pandas dataframe to numpy array
        if dimension == 2:
            array = dataframe[['Latitude','Longitude']].to_numpy()
        elif dimension == 3:
            array = dataframe[['Latitude','Longitude', 'Altitude']].to_numpy()
        else:
            print("Error occured - dimensionality is illegal: ", dimension)

        return (array)


    def drop_nth_row(self, dataframe, nth_row=2):
        '''
        :params dataframe: pandas dataframe.
        :params nth_row: Selects every nth row starting from 0.
        :returns pandas dataframe with reduced number of rows.
        '''
        df_reduced = dataframe[dataframe.index % nth_row == 0]
        return (df_reduced)
