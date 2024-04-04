import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.special import comb
import math 
import numpy as np
import matplotlib.pyplot as plt
from mpl_toolkits.mplot3d import Axes3D
from scipy.spatial import Delaunay

# Function to compute the factorial
def factorial(n):
    return math.factorial(n)

# Function to compute the binomial coefficient
def binomial_coeff(n, k):
    return factorial(n) // (factorial(k) * factorial(n - k))

# Function to compute points on a cubic Bézier triangle using the de Casteljau algorithm
def de_casteljau(control_points, u, v, w):
    n = 3  # Degree of the Bézier triangle
    # Ensure the sum of u, v, w is 1
    if not np.isclose(u + v + w, 1):
        raise ValueError("The barycentric coordinates must sum up to 1.")
    point = np.zeros(3)  # Initialize the point in 3D space
    for i in range(n + 1):
        for j in range(n - i + 1):
            k = n - i - j
            # Compute the Bernstein basis polynomial value for the current i, j, k
            b = binomial_coeff(n, i) * binomial_coeff(n - i, j) * (u**i) * (v**j) * (w**k)
            # Compute the control point index based on i, j, k
            index = (i, j, k)
            # Add the influence of the current control point to the final point on the surface
            point += b * np.array(control_points[index])
    return point


def calculate_barycentric_coordinates(A, B, C, P):
    # Convert points to numpy arrays for vector operations
    A, B, C, P = map(np.array, [A, B, C, P])
    
    # Compute vectors
    v0 = B - A
    v1 = C - A
    v2 = P - A
    
    # Compute dot products
    d00 = np.dot(v0, v0)
    d01 = np.dot(v0, v1)
    d11 = np.dot(v1, v1)
    d20 = np.dot(v2, v0)
    d21 = np.dot(v2, v1)
    
    # Compute barycentric coordinates
    denom = d00 * d11 - d01 * d01
    v = (d11 * d20 - d01 * d21) / denom
    w = (d00 * d21 - d01 * d20) / denom
    u = 1.0 - v - w
    
    return u, v, w

def points_to_account(patch_control_points, shared_edges_extremities, patch_ids):
    initial_patch_id, adjacent_patch_id = patch_ids
    shared_edge_info = shared_edges_extremities.get(patch_ids)
    
    # Initialize an empty list for points to adjust
    points_to_account1 = []

    if not shared_edge_info:
        print("No shared edge defined for the given patch IDs.")
        return points_to_account1
    
    initial_edge, adjacent_edge = shared_edge_info['initial'], shared_edge_info['adjacent']
    # Comparing the structure of shared edges
    if (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (0, 3, 0)) or (initial_edge[0], initial_edge[3]) == ((0, 3, 0), (0, 0, 3)) :
        
        if (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (0, 3, 0)):
            points_to_account1 = [(1, 0, 2), (1, 1, 1), (1, 2, 0)]
            
        else:
            points_to_account1 = [(1, 2, 0),(1, 1, 1), (1, 0, 2)]
            
    elif (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (3, 0, 0)) or (initial_edge[0], initial_edge[3]) == ((3, 0, 0), (0, 0, 3)) :
        if (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (3, 0, 0)):
            points_to_account1 = [(0, 1, 2), (1, 1, 1), (2, 1, 0)]
        else:
            points_to_account1 = [(2, 1, 0), (1, 1, 1), (0, 1, 2)]

    elif (initial_edge[0], initial_edge[3]) == ((3, 0, 0), (0, 3, 0)) or (initial_edge[0], initial_edge[3]) == ((0, 3, 0), (3, 0, 0)) :
        if (initial_edge[0], initial_edge[3]) == ((3, 0, 0), (0, 3, 0)):
            points_to_account1 = [(2, 0, 1), (1, 1, 1), (0, 2, 1)]
        else:
            points_to_account1 = [(0, 2, 1), (1, 1, 1), (2, 0, 1)]

    return points_to_account1

def getopppoint(patch_control_points, shared_edges_extremities, patch_ids):
    initial_patch_id, adjacent_patch_id = patch_ids
    shared_edge_info = shared_edges_extremities.get(patch_ids)

    # Initialize an empty list for points to adjust
    points_to_account1 = []

    if not shared_edge_info:
        print("No shared edge defined for the given patch IDs.")
        return points_to_account1
    
    initial_edge, adjacent_edge = shared_edge_info['initial'], shared_edge_info['adjacent']
    # Comparing the structure of shared edges to get the point opposite to the shared edge 
    if (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (0, 3, 0)) or (initial_edge[0], initial_edge[3]) == ((0, 3, 0), (0, 0, 3)) :
        key_C = (3,0,0)
        
    elif (initial_edge[0], initial_edge[3]) == ((0, 0, 3), (3, 0, 0)) or (initial_edge[0], initial_edge[3]) == ((3, 0, 0), (0, 0, 3)) :
        key_C = (0,3,0)

    elif (initial_edge[0], initial_edge[3]) == ((3, 0, 0), (0, 3, 0)) or (initial_edge[0], initial_edge[3]) == ((0, 3, 0), (3, 0, 0)) :
        key_C = (0,0,3)


    return key_C
def adjust_control_points_for_C1(patch_control_points, patch_ids, shared_edges_extremities):
    """
    Adjusts specific control points in the adjacent patch based on the shared edge extremities,
    taking into account the global shared_edges_extremities mapping.
    
    patch_control_points: Dictionary of patch IDs to their control points dictionaries.
    patch_ids: Tuple of (initial_patch_id, adjacent_patch_id) identifying the patches to adjust.
    shared_edges_extremities: Global mapping of shared edges between patches.
    """
    initial_patch_id, adjacent_patch_id = patch_ids
    initial_patch = patch_control_points[initial_patch_id]
    adjacent_patch = patch_control_points[adjacent_patch_id]
    u1 = 0
    u2 = 0
    u3 = 0
    points_to_adjust = []
    
    # Extract the shared edge extremities for the given patches
    shared_edge = shared_edges_extremities.get(patch_ids)
    if not shared_edge:
        print("No shared edge defined for the given patch IDs.")
        return
    
    initial_edge = shared_edge['initial']
    adjacent_edge = shared_edge['adjacent']

    # the control points of the first triangle behind the first set of points on the edge 
    points_to_account1 = points_to_account(patch_control_points,shared_edges_extremities, patch_ids)
    
    # determining points to adjust based on the orientation of the shared edge
    if (adjacent_edge[0], adjacent_edge[3]) == ((0, 0, 3), (0, 3, 0)) or (adjacent_edge[0], adjacent_edge[3]) == ((0, 3, 0), (0, 0, 3)) :
        P_key = (3,0,0)
        C_key = getopppoint(patch_control_points, shared_edges_extremities, patch_ids)
        A = [initial_patch[initial_edge[3]][0], initial_patch[initial_edge[3]][1]]
        B = [initial_patch[initial_edge[0]][0], initial_patch[initial_edge[0]][1]]
        C = [initial_patch[C_key][0], initial_patch[C_key][1]]
        P = [adjacent_patch[P_key][0], adjacent_patch[P_key][1]] 
        u1, u2, u3 = calculate_barycentric_coordinates(A, B, C, P)
        if (adjacent_edge[0], adjacent_edge[3]) == ((0, 0, 3), (0, 3, 0)):
            points_to_adjust = [(1, 0, 2), (1, 1, 1), (1, 2, 0)]
        else :
            points_to_adjust = [(1, 2, 0), (1, 1, 1), (1, 0, 2)]

    elif (adjacent_edge[0], adjacent_edge[3]) == ((0, 0, 3), (3, 0, 0)) or (adjacent_edge[0], adjacent_edge[3])== ((3, 0, 0), (0, 0, 3)):
        P_key = (0,3,0)
        C_key = getopppoint(patch_control_points, shared_edges_extremities, patch_ids)
        A = [initial_patch[initial_edge[3]][0], initial_patch[initial_edge[3]][1]]
        B = [initial_patch[initial_edge[0]][0], initial_patch[initial_edge[0]][1]]
        C = [initial_patch[C_key][0], initial_patch[C_key][1]]
        P = [adjacent_patch[P_key][0], adjacent_patch[P_key][1]] 
        
        u1, u2, u3 = calculate_barycentric_coordinates(A, B, C, P) 
        if (adjacent_edge[0], adjacent_edge[3]) == ((0, 0, 3), (3, 0, 0)) :
            points_to_adjust = [(0, 1, 2), (1, 1, 1), (2, 1, 0)]
        else : 
            points_to_adjust = [(2, 1, 0), (1, 1, 1), (0, 1, 2)]

    elif (adjacent_edge[0], adjacent_edge[3]) == ((3, 0, 0), (0, 3, 0)) or (adjacent_edge[0], adjacent_edge[3]) == ((0, 3, 0), (3, 0, 0)):
        P_key = (0,0,3)
        C_key = getopppoint(patch_control_points, shared_edges_extremities, patch_ids)
        A = [initial_patch[initial_edge[3]][0], initial_patch[initial_edge[3]][1]]
        B = [initial_patch[initial_edge[0]][0], initial_patch[initial_edge[0]][1]]
        C = [initial_patch[C_key][0], initial_patch[C_key][1]]
        P = [adjacent_patch[P_key][0], adjacent_patch[P_key][1]] 
        u1, u2, u3 = calculate_barycentric_coordinates(A, B, C, P)
        if (adjacent_edge[0], adjacent_edge[3]) == ((3, 0, 0), (0, 3, 0)):
            points_to_adjust = [(2, 0, 1), (1, 1, 1), (0, 2, 1)]
        else :
            points_to_adjust = [(0, 2, 1), (1, 1, 1), (2, 0, 1)]

    # COntinuite C0 : make sure that the points of control on the edge are the same
    adjacent_patch[adjacent_edge[0]] = initial_patch[initial_edge[0]]
    adjacent_patch[adjacent_edge[1]] = initial_patch[initial_edge[1]]
    adjacent_patch[adjacent_edge[2]] = initial_patch[initial_edge[2]]
    adjacent_patch[adjacent_edge[3]] = initial_patch[initial_edge[3]]

    # Adjust the specified control points in the adjacent patch
    adjacent_patch[points_to_adjust[0]] = u1*initial_patch[initial_edge[1]] + u2*initial_patch[initial_edge[0]] + u3*initial_patch[points_to_account1[0]]
    adjacent_patch[points_to_adjust[1]] = u1*initial_patch[initial_edge[2]] + u2*initial_patch[initial_edge[1]] + u3*initial_patch[points_to_account1[1]]
    adjacent_patch[points_to_adjust[2]] = u1*initial_patch[initial_edge[3]] + u2*initial_patch[initial_edge[2]] + u3*initial_patch[points_to_account1[2]]


def reflect_across_YZ(patch):
    return {key: np.array([-value[0], value[1], value[2]]) for key, value in patch.items()}


# Instead of defining a fixed list of colors, use a function to cycle through a predefined set of colors.
def get_color(patch_id):
    color_cycle = ['blue', 'red', 'green', 'purple', 'orange', 'cyan', 'magenta', 'yellow', 'black', 'grey']
    return color_cycle[patch_id % len(color_cycle)]


