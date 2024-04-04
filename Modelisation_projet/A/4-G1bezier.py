from fonctions_bezier import *

# Generate the control points for a cubic Bézier triangle
control_points = {
    (0, 0, 3): np.array([0, 0, 10]),
    (0, 1, 2): np.array([0, 10/3, 2]),
    (0, 2, 1): np.array([0, 20/3, 2]),
    (0, 3, 0): np.array([0, 10, 0.5]),
    (1, 0, 2): np.array([10/3, 0, 7.5]),
    (1, 1, 1): np.array([10/3, 10/3, 2]),
    (1, 2, 0): np.array([4, 6, 1]),
    (2, 0, 1): np.array([20/3, 0, 4]),
    (2, 1, 0): np.array([6, 4, 2]),
    (3, 0, 0): np.array([10, 0, 10]),
}

second_control_points = {
    (0, 0, 3): np.array([11, 11, 10]),
    (0, 1, 2): np.array([20/3, 11, 2]),
    (0, 2, 1): np.array([10/3, 11, 2]),
    (0, 3, 0): np.array([0, 10, 0.5]), #
    (1, 0, 2): np.array([22/3, 2, 7.5]),
    (1, 1, 1): np.array([22/3, 22/3, 2]),
    (1, 2, 0): np.array([6, 4, 1]), #
    (2, 0, 1): np.array([11, 11/3, 2]),
    (2, 1, 0): np.array([4, 6, 2]),  #
    (3, 0, 0): np.array([10, 0, 10]), #
}

#Calculate the barycentric coordinates of the point (0,0,3) with respect to the first traingle 
A =  [control_points[(0,3,0)][0], control_points[(0,3,0)][1]]
B = [control_points[(3,0,0)][0], control_points[(3,0,0)][1]]
C =  [control_points[(0,0,3)][0], control_points[(0,0,3)][1]]
P = [second_control_points[(0,0,3)][0], second_control_points[(0,0,3)][1]] 
u1, u2, u3 = calculate_barycentric_coordinates(A, B, C, P)

#On modifie parsuite les coordonnées pour assurer G1
second_control_points = {
    (0, 0, 3): np.array([11, 11, 10]),
    (0, 1, 2): np.array([8, 10, 4]),
    (0, 2, 1): u1*control_points[(1,2,0)]+u2*control_points[(0,3,0)]+u3*control_points[(0,2,1)],
    (0, 3, 0): np.array([0, 10, 0.5]), #
    (1, 0, 2): np.array([10, 7.5, 3.5]),
    (1, 1, 1): u1*control_points[(2,1,0)]+u2*control_points[(1,2,0)]+u3*control_points[(1,1,1)],
    (1, 2, 0): np.array([4, 6, 1]), #
    (2, 0, 1): u1*control_points[(3,0,0)]+u2*control_points[(2,1,0)]+u3*control_points[(2,0,1)],
    (2, 1, 0): np.array([6, 4, 2]),  #
    (3, 0, 0): np.array([10, 0, 10]), #
}

# Calculate points on the Bézier triangle
num_samples = 40
bezier_points = np.array([de_casteljau(control_points, u, v, 1 - u - v) 
                          for u in np.linspace(0, 1, num_samples)
                          for v in np.linspace(0, 1 - u, num_samples)])

# Calculate points on the second Bézier triangle
second_bezier_points = np.array([
    de_casteljau(second_control_points, u, v, 1 - u - v) 
    for u in np.linspace(0, 1, num_samples)
    for v in np.linspace(0, 1 - u, num_samples)
])

# Visualization

# Visualization with a scatter plot
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the first Bézier surface points
ax.plot_trisurf(bezier_points[:, 0], bezier_points[:, 1], bezier_points[:, 2], color='blue', alpha=0.6)

# Plot the second Bézier surface points
ax.plot_trisurf(second_bezier_points[:, 0], second_bezier_points[:, 1], second_bezier_points[:, 2], color='red', alpha=0.6)


# Plot the control points of the first Bézier surface with labels
for index, point in control_points.items():
    ax.scatter(*point, color='red', s=50)
    label = f'c{index}'
    ax.text(*point, label, size=8, zorder=1, color='k')

# Plot the control points of the second Bézier surface with labels
for index, point in second_control_points.items():
    ax.scatter(*point, color='green', s=50)
    label = f'c{index}'
    ax.text(*point, label, size=8, zorder=1, color='k')


# No need to perform Delaunay triangulation again unless you want to triangulate the combined set of control points

# Set labels and show plot
ax.set_title('Two Stitched Bézier Surfaces')
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.show()

