import numpy as np
import pandas as pd
import matplotlib.pyplot as plt 
import matplotlib.cm as cm
import itertools

#from fonctions_tp1_interpolation import lagrange, lagrange_param, neville_param
from fonctions_tp1_approximation import *

### Variable globale Interpolation
borne_max = 1000
epsilon = 1.0/10
liste_couleurs = ['blue', 'cyan', 'green', 'magenta', 'red', 'yellow']

### Genere un ensemble de point sans ambuigité des abscisses
def generate_points(nb_pts, b_max= borne_max):
    X = [np.round(i,2)/(borne_max) for i in np.random.randint(b_max, size=(nb_pts))]
    Y = [np.round(i,2)/(borne_max) for i in np.random.randint(b_max, size=(nb_pts))]
    # Vérification : Non double abscisses 
    # while (len(list(pd.Series(X).value_counts().to_dict().values())) != nb_pts):
    #    X = [np.round(i,2)/(borne_max) for i in np.random.randint(b_max, size=(nb_pts))]
    return X,Y


###################################################################################################################
################################################## Approximation ##################################################
###################################################################################################################

### Affiche toutes les étapes de la surface 3D en produit tensoriel
def show_surface(X, Y, Z, interpolated_surface):

    fig = plt.figure(figsize=(12,15))
    ax = fig.add_subplot(131, projection='3d')
    ax.set_title('Points de contrôle')
    ax.scatter(X, Y, Z, c= 'red')

    if interpolated_surface[0].shape[0] != 0:
        ax3 = fig.add_subplot(132, projection='3d')
        ax3.set_title('Echantillonnage')
        ax3.scatter(X, Y, Z, c= 'red')
        ax3.scatter(interpolated_surface[:,:,0].reshape(-1,1),interpolated_surface[:,:,1].reshape(-1,1), interpolated_surface[:,:,2].reshape(-1,1))
        for i in range(interpolated_surface.shape[0]):
            ax3.plot(interpolated_surface[i,:,0], interpolated_surface[i,:,1], interpolated_surface[i,:,2])
            ax3.plot(interpolated_surface[:,i,0], interpolated_surface[:,i,1], interpolated_surface[:,i,2])
            
        ax5 = fig.add_subplot(133, projection='3d')
        ax5.set_title('Surface interpolante')
        ax5.scatter(X, Y, Z, c= 'red')
        ax5.plot_surface(interpolated_surface[:,:,0], interpolated_surface[:,:,1], interpolated_surface[:,:,2], cmap='viridis', edgecolor='k')


    plt.show()

