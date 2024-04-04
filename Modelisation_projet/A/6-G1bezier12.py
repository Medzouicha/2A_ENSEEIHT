from fonctions_bezier import *
#


# Structuring patches with their control points
patches = {

    1: {
        (0, 0, 3): np.array([1.86, 1.85, 5]),
        (0, 1, 2): np.array([2.97, 4.01, 4]),
        (0, 2, 1): np.array([4.40, 6.8, 6]),
        (0, 3, 0): np.array([5.22, 8.37, 5]),
        (1, 0, 2): np.array([4.58, 2.4, 4]),
        (1, 1, 1): np.array([6.16, 5.27, 5]),
        (1, 2, 0): np.array([6.5, 7.37, 5]),
        (2, 0, 1): np.array([8, 3.11, 6]),
        (2, 1, 0): np.array([8.9, 5.5, 5]),
        (3, 0, 0): np.array([11.18, 3.75, 5]),
    },
    2: {
        (0, 0, 3): np.array([15, 12.9, 5]),
        (0, 1, 2): np.array([11.8, 11.4, 5]),
        (0, 2, 1): np.array([8.15, 9.7, 5]),
        (0, 3, 0): np.array([5.22, 8.37, 5]),  # Referencing from patch 1
        (1, 0, 2): np.array([13.8, 10, 6]),
        (1, 1, 1): np.array([10, 8, 5]),
        (1, 2, 0): np.array([6.5, 7.37, 5]),  # Referencing from patch 1
        (2, 0, 1): np.array([12.3, 6.38, 5]),
        (2, 1, 0): np.array([8.9, 5.5, 5]),  # Referencing from patch 1
        (3, 0, 0): np.array([11.18, 3.75, 5]),  # Referencing from patch 1
    },
    # Add other patches as needed
}
shared_edges_extremities = {
    (1, 2): {
        'initial': [(3, 0, 0),(2,1,0),(1,2,0),(0, 3, 0)],
        'adjacent': [(3, 0, 0),(2,1,0),(1,2,0),(0, 3, 0)],
    },
    (2,3): {
        'initial': [(0, 3, 0),(0,2,1),(0,1,2),(0, 0, 3)],
        'adjacent': [(3, 0, 0),(2,0,1),(1,0,2),(0, 0, 3)],

    },
    (3, 4): {
    'initial': [(0, 3, 0),(1,2,0),(2,1,0),(3, 0, 0)],
    'adjacent': [(0, 3, 0),(1,2,0),(2,1,0),(3, 0, 0)],
    },
    (4, 5): {
    'initial': [(0, 0, 3),(1,0,2),(2,0,1),(3, 0, 0)],
    'adjacent': [(0, 0, 3),(0,1,2),(0,2,1),(0, 3, 0)],
    },
    (1, 5): {
    'initial': [(0, 0, 3),(0,1,2),(0,2,1),(0, 3, 0)],
    'adjacent': [(3, 0, 0),(2,1,0),(1,2,0),(0, 3, 0)],
    },
    # Add mappings for other shared edges between other patches as needed
}



#Only two patches
adjust_control_points_for_C1(patches, (1, 2), shared_edges_extremities)


# Calculate points on the Bézier triangle
num_samples = 10

# Initialize a list to hold Bézier surface points for each patch
all_bezier_points = []

# Generate Bézier points for each patch
for patch_id, control_points in patches.items():
    bezier_points = np.array([
        de_casteljau(control_points, u, v, 1 - u - v)
        for u in np.linspace(0, 1, num_samples)
        for v in np.linspace(0, 1 - u, num_samples)
    ])
    all_bezier_points.append(bezier_points)

# Visualization
fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')


# Assign different colors for each patch for distinction
colors = ['blue', 'red', 'green', 'purple', 'orange']

for bezier_points, color in zip(all_bezier_points, colors):
    ax.plot_trisurf(bezier_points[:, 0], bezier_points[:, 1], bezier_points[:, 2], color=color, alpha=0.6)

# Optional: Plot control points for each patch
for patch_id, control_points in patches.items():
    color = colors[patch_id - 1]  # Assuming patch IDs start at 1 and are sequential
    for index, point in control_points.items():
        ax.scatter(*point, color=color, s=50)
        label = f'Patch {patch_id}: c{index}'
        ax.text(*point, label, size=6, zorder=1, color=color)

# Setting labels and adjusting plot
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.set_title('Five Triangular Bézier Surfaces stitched (showing only two patches)')
plt.show()
