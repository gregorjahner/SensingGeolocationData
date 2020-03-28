import numpy as np
import matplotlib.pyplot as plt
from matplotlib import cm
from matplotlib.ticker import LinearLocator, FormatStrFormatter
from mpl_toolkits.mplot3d import Axes3D


def visualize_dataframe(df):
    '''
    Visualize the Geolocation dataframe which consists of "Latitude", "Longitude", "Altitude" and "Timestamp".
    :params df: pandas dataframe.
    '''
    # 2D-arrays from DataFrame
    x = np.linspace(df['Latitude'].min(), df['Latitude'].max(), len(df['Latitude']))
    y = np.linspace(df['Longitude'].min(), df['Longitude'].max(), len(df['Longitude']))

    x_, y_ = np.meshgrid(x, y)

    # Interpolate unstructured D-dimensional data.
    z2 = griddata((df['Latitude'], df['Longitude']), df['Altitude'], (x_, y_), method='cubic')

    # Ready to plot
    fig = plt.figure()
    ax = fig.gca(projection='3d')
    surf = ax.plot_surface(x2, y2, z2, rstride=1, cstride=1, cmap=cm.coolwarm, linewidth=0, antialiased=False)
    ax.set_zlim(-1.01, 1.01)

    ax.zaxis.set_major_locator(LinearLocator(10))
    ax.zaxis.set_major_formatter(FormatStrFormatter('%.02f'))

    fig.colorbar(surf, shrink=0.5, aspect=5)
    plt.title('Geolocation')

    plt.show()
