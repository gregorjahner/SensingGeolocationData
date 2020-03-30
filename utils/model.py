import numpy as np
import pandas as pd

class ClusteringFrame():
    """
    This framework should work as a preprocessing step in order to make sense out of
    the huge amount of data. Define the data in some kind of sense.
    """
    def __init__(self):
        super(ClusteringFrame, self).__init__()

    # Helper functions
    def euclidean_centroid(self, X):
        """
        return the center of mass of data points of X.
        :param X: a sub-matrix of the NxD data matrix that defines a cluster.
        :return: the centroid of the cluster.
        """
        centroid = np.mean(X, axis=0)
        return (centroid)

    def euclid(self, X, Y):
        """
        return the pair-wise euclidean distance between two data matrices.
        :param X: NxD matrix.
        :param Y: MxD matrix.
        :return: NxM euclidean distance matrix.
        """
        #if X.shape[1] != Y.shape[1]:
            #raise AssertionError(f"Dim of X {X.shape} does not match the Dim of Y {Y.shape}.")

        distances = [np.linalg.norm(x - Y, axis=1) for x in X]
        return (distances)

    def kmeans_pp_init(self, X, k, metric):
        """
        The initialization function of kmeans++, returning k centroids.
        :param X: The data matrix.
        :param k: The number of clusters.
        :param metric: a metric function like specified in the kmeans documentation.
        :return: kxD matrix with rows containing the centroids.
        """
        # Choose the first centroid uniformly at random among the data points.
        start = X[np.random.choice(X.shape[0], 1, replace=False), :]
        centroids = start

        for idx in range(1, k):
            #For each point xi compute the distance.
            #distances = np.array(metric(X, centroids))
            distances = np.array(self.euclid(X, centroids))

            # keep the lowest of the computed distances between all choosen centroids.
            dist = np.array([cdist.min() for cdist in distances])

            # Prepare for choosing by weightend probability distribution.
            one_d = dist.flatten()
            normed = [float(i)/sum(one_d) for i in one_d]
            #normed[np.isnan(normed)] = 0

            # Sample the next centroid from points with probability proportional to distance.
            choice = X[np.random.choice(X.shape[0], 1, replace=False, p=normed), :]
            centroids = np.append(centroids, choice, axis=0)

            print("initialize centroid number: ", idx)
        print("Initialization of centroids finished.")

        return (centroids)


    def kmeans(self, X, k, iterations=10, metric=euclid, center=euclidean_centroid, init=kmeans_pp_init):
        """
        The K-Means function, clustering the data X into k clusters.
        :param X: A NxD data matrix.
        :param k: The number of desired clusters.
        :param iterations: The number of iterations.
        :param metric: A function that accepts two data matrices and returns their
                pair-wise distance. For a NxD and KxD matrices for instance, return
                a NxK distance matrix.
        :param center: A function that accepts a sub-matrix of X where the rows are
                points in a cluster, and returns the cluster centroid.
        :param init: A function that accepts a data matrix and k, and returns k initial centroids.
        :param stat: A function for calculating the statistics we want to extract about
                    the result (for K selection, for example).
        :return: a tuple of (clustering, centroids, statistics)
        clustering - A N-dimensional vector with indices from 0 to k-1, defining the clusters.
        centroids - The kxD centroid matrix.
        """
        # Initialize the centroids.
        centroids = self.kmeans_pp_init(X, k, metric)

        for idx in range(iterations):
            dist = np.array(metric(X, centroids))
            # Update cluster indicators.
            clustering = np.array([point.argmin() for point in dist])
            # Update centroids.
            new_centroids = np.array([center(X[clustering == i]) for i in range(k)])
            #Check for convergence.
            if np.all(centroids == new_centroids):
                break
            centroids = new_centroids

            print("kmeans iteration step: ", idx)

        return (centroids, clustering)
