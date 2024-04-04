
import numpy as np
import matplotlib.pyplot as plt 
import matplotlib.cm as cm
import math

## Renvoie nb_ech echantillon entre borne_min et borne_max
def tToEvaluate(borne_min, borne_max, nb_ech):
    x_fonc = []; x_tmp = borne_min
    pas = (borne_max - borne_min)/(nb_ech-1)
    while(x_tmp <= borne_max):
        x_fonc.append(x_tmp)
        x_tmp += pas
    x_fonc.append(borne_max) 
    
    return x_fonc

def echantillonnage(nb_ech):
    #  fonction : echantillonnage                                                  
    #  semantique : génére l'ensemble des temps d'évaluation 
    #               à partir du nombre d'échantillon                 
    #  params :                                                             
    #           - int nb_ech : nombre d'échantillon                 
    #  sortie :                      
    #            - List<float> list_tt : temps d'évaluation  

    list_tt = [0] 
    list_tt = np.linspace(0,1, nb_ech)


    return list_tt

def k_parmi_n(k, n):
    #  fonction : k_parmi_n                                                  
    #  semantique : calculs de coefficient binomial           
    return math.factorial(n)/(math.factorial(k)*math.factorial(n-k))


def build_polys_bernstein(degre_max, list_tt) -> list:
    #  fonction : build_polys_bernstein                                                  
    #  semantique : construit les polynomes de Beisntein jusqu'au degré degre_max                
    #  params :                                                             
    #           - int degre_max : degré max         
    #           - float list_tt : t d'évaluation         
    #  sortie :  - une liste de matrices de taille [len(list_tt) x 2] liste_points: la liste  
    #              contenant degre_max matrices de points 2D, une pour chaque polynome de Bernstein.
    #              Chaque matrice contient len(list_tt) points.
    #     

    liste_points = [i for i in range(degre_max+1)]
    for k in range(degre_max+1):
        liste_base = [i for i in range(len(list_tt))]
        for t in range(len(list_tt)):
            bk = k_parmi_n(k, degre_max)*((1-list_tt[t])**(degre_max-k))*(list_tt[t]**k)
            liste_base[t] = bk
        liste_points[k] = [list_tt, liste_base]

    return liste_points

def DeCasteljau(DD, tt):
    #  fonction : DeCasteljau                                                  
    #  semantique : applique l'aglgorithme de DCJ sur les valeurs de DD    
    #              pour une courbe définie par les points de controle                  
    #  params :                                                             
    #           - List<float> DD : liste de valeur à approximer (abscisses ou ordonnées)                        
    #           - float tt : temps d'évaluation     
    #                 
    #  sortie : - float d : valeur (abscisses ou ordonnées)  approximée en tt 
    #    
    d = 0 
    for k in range(len(DD)):
        d += DD[k]*k_parmi_n(k, len(DD)-1)*((1-tt)**(len(DD)-k-1))*(tt**k)

        
    return d

def subdivision(X,Y):
    #  fonction : subdivision                                                  
    #  semantique : correspond à 1 étape de subdivision
    #                             
    #  params :                                                             
    #           - List<float> XX : abscisses des point de controle       
    #           - List<float> YY : odronnees des point de controle        
    #                 
    #  sortie :  (List<float> QX, List<float> QY, List<float> RX,
    #            List<float> RY) : 
    #            Listes contenant les abscisses et les ordonnées des
    #             deux nouvelles familles Q et R 
    
    n= len(X)
    QX = [X[0]]
    QY = [Y[0]]
    RX = [X[n-1]]
    RY = [Y[n-1]]
    XX = X.copy()
    YY = Y.copy()
    
    for i in range(1,n):
        for j in range(n-i):
            XX[j] = (1/2) *XX[j] +(1/2)*XX[j+1]
            YY[j] = (1/2) *YY[j] +(1/2)*YY[j+1]
        QX.append(XX[0])
        QY.append(YY[0])
        RX.append(XX[n-i-1])
        RY.append(YY[n-i-1])

    
    RX.reverse()
    RY.reverse()
    return QX, QY, RX, RY

def DeCasteljauSub(X, Y, nombreDeSubdivision):
    XSubdivision = []
    YSubdivision = []
    XSubdivisionQ = []
    YSubdivisionQ = []
    XSubdivisionR = []
    YSubdivisionR = []
    QX, QY, RX, RY = subdivision(X, Y)  # Copie des listes X et Y

    if nombreDeSubdivision - 1 != 0:
        (XSubdivisionQ, YSubdivisionQ) = DeCasteljauSub(QX, QY, nombreDeSubdivision - 1)
        (XSubdivisionR, YSubdivisionR) = DeCasteljauSub(RX, RY, nombreDeSubdivision - 1)
        for e in XSubdivisionQ + XSubdivisionR:
            XSubdivision.append(e)
        for e in YSubdivisionQ + YSubdivisionR:
            YSubdivision.append(e)
    else:
        for e in QX + RX:
            XSubdivision.append(e)
        for e in QY + RY:
            YSubdivision.append(e)
    
    return (XSubdivision, YSubdivision)


        


def approximation_surface(XX, YY, ZZ, list_tt, nb_point_grille):
    #  fonction : appromation_surface                                                  
    #      semantique : calcule les points atteints par la surface en chauqe temps d'évaluation     
    #                                    
    #      params :                                                             
    #               - Array<float> XX : coorodnnées X des points de controle 3D         
    #               - Array<float> YY : coorodnnées Y des points de controle 3D         
    #               - Array<float> ZZ : coorodnnées Z des points de controle 3D        
    #               - List<float> list_tt : temps d'évaluation                
    #      sortie : 
    #               - Array<vfloat> : coordonnées 3D des points de la surface approximée, 
    #                 la dimension associée est : (nb_echantillon, nb_echantillon, 3)
    def Casteljau3D(XX, YY, ZZ, list_tt) :
        liste_points_x = []
        liste_points_y = []
        liste_points_z = []
        for tt in list_tt:
            liste_points_x.append(DeCasteljau(XX, tt))
            liste_points_y.append(DeCasteljau(YY, tt))
            liste_points_z.append(DeCasteljau(ZZ, tt))
        return (liste_points_x,liste_points_y,liste_points_z)
   
    n = len(XX)
    interpolate_surface = np.zeros((len(list_tt),len(list_tt),3))

    C_X = np.zeros((n,len(list_tt)))
    C_Y= np.zeros((n,len(list_tt)))
    C_Z= np.zeros((n,len(list_tt)))
    for i in range (nb_point_grille) :
        X, Y , Z = Casteljau3D(XX[i,:], YY[i,:],ZZ[i,:] , list_tt)   
        C_X[i,:] = np.array(X)
        C_Y[i,:] = np.array(Y)
        C_Z[i,:] = np.array(Z)

   

    for j in range (len(list_tt)) :
        S_X, S_Y , S_Z = Casteljau3D(list(C_X[:,j]), list(C_Y[:,j]),list(C_Z[:,j]), list_tt)
        interpolate_surface[:,j,0] = np.array(S_X)
        interpolate_surface[:,j,1] = np.array(S_Y)
        interpolate_surface[:,j,2] = np.array(S_Z)
    return interpolate_surface


