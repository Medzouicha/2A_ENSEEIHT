from fonctions_bezier import *

####  Generate one triangular bezier patch


# Generate the control points for a cubic Bézier triangle
control_points = {
    (0, 0, 3): np.array([0, 0, 10]),
    (0, 1, 2): np.array([0, 10/3, 2]),
    (0, 2, 1): np.array([0, 20/3, 2]),
    (0, 3, 0): np.array([0, 10, 0.5]),
    (1, 0, 2): np.array([10/3, 0, 7.5]),
    (1, 1, 1): np.array([10/3, 10/3, 2]),
    (1, 2, 0): np.array([10/3, 8, 1]),
    (2, 0, 1): np.array([20/3, 0, 2]),
    (2, 1, 0): np.array([6, 6, 2]),
    (3, 0, 0): np.array([10, 0, 10]),
}



# Calculate points on the Bézier triangle
num_samples = 10
bezier_points = np.array([de_casteljau(control_points, u, v, 1 - u - v) 
                          for u in np.linspace(0, 1, num_samples)
                          for v in np.linspace(0, 1 - u, num_samples)])

# Visualization

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot the Bézier surface points
ax.plot_trisurf(bezier_points[:, 0], bezier_points[:, 1], bezier_points[:, 2], color='blue', alpha=0.6)

# Convert the dictionary to an array of points for Delaunay triangulation
points = np.array(list(control_points.values()))

# (Optional) Perform Delaunay triangulation on the projected points to the XY plane
tri = Delaunay(points[:, :2])

# Plot the vertices of the Delaunay triangles as red dots
ax.scatter(points[:, 0], points[:, 1], points[:, 2], color='red', s=50)

# Annotate the points
# Plot the control points of the first Bézier surface with labels
for index, point in control_points.items():
    ax.scatter(*point, color='red', s=50)
    label = f'c{index}'
    ax.text(*point, label, size=8, zorder=1, color='k')
# Plot the edges of the Delaunay triangles
for simplex in tri.simplices:
    # Extract the vertices for each simplex (triangle)
    vertices = points[simplex]
    # Plot the edges
    for i in range(3):
        start_point = vertices[i]
        end_point = vertices[(i + 1) % 3]
        ax.plot([start_point[0], end_point[0]], [start_point[1], end_point[1]], [start_point[2], end_point[2]], color='grey', lw = 1.2)

# Set labels and show plot
ax.set_title('One triangular bezier patch : cubic ')
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')

plt.show()
