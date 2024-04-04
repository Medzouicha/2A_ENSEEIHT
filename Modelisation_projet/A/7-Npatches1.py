from fonctions_bezier import *


# Structuring patches with their control points

patches = {
    1: {
        (0, 0, 3): np.array([0.0, 20.99, 29.95]),
        (0, 1, 2): np.array([2.98, 21.96, 29.81]),
        (0, 2, 1): np.array([6.48, 23.14, 29.5]),
        (0, 3, 0): np.array([10.0, 24.67, 28.84]),
        (1, 0, 2): np.array([0.0, 23.77, 29.26]),
        (1, 1, 1): np.array([3.27, 25.1, 28.6]),
        (1, 2, 0): np.array([6.39, 26.57, 27.54]),
        (2, 0, 1): np.array([0.0, 26.53, 27.57]),
        (2, 1, 0): np.array([3.19, 27.58, 26.52]),
        (3, 0, 0): np.array([0.0, 28.33, 25.54])
        }
,
    2: {
        (0, 0, 3): np.array([10.0, 29.81, 21.96]),
        (0, 1, 2): np.array([10.0, 29.0, 24.36]),
        (0, 2, 1): np.array([10.0, 27.34, 26.8]),
        (0, 3, 0): np.array([10.0, 24.67, 28.84]),
        (1, 0, 2): np.array([6.67, 29.58, 22.85]),
        (1, 1, 1): np.array([6.8, 28.28, 25.61]),
        (1, 2, 0): np.array([6.39, 26.57, 27.54]),
        (2, 0, 1): np.array([3.26, 29.13, 24.09]),
        (2, 1, 0): np.array([3.19, 27.58, 26.52]),
        (3, 0, 0): np.array([0.0, 28.33, 25.54])
        },
    3: {
        (0, 0, 3): np.array([10.0, 29.81, 21.96]),  # M
        (0, 1, 2): np.array([6.65, 29.75, 20.4]),  # T
        (0, 2, 1): np.array([3.29, 29.69, 19.84]),  # V ###
        (0, 3, 0): np.array([0.9, 29.63, 18.7]),  # S ######
        (1, 0, 2): np.array([6.67, 29.58, 22.85]),  # Q
        (1, 1, 1): np.array([3.35, 29.81, 21.96]),  # U
        (1, 2, 0): np.array([0.0, 29.99, 21.47]),  # Z ###
        (2, 0, 1): np.array([3.26, 29.13, 24.09]),  # R
        (2, 1, 0): np.array([0.0, 29.48, 23.18]),  # W
        (3, 0, 0): np.array([0.0, 28.33, 25.54]),  # E
        },

    9: {
        (0, 0, 3): np.array([10.0, 11.81, 25.74]),
        (0, 1, 2): np.array([7.25, 14.0, 28.0]),
        (0, 2, 1): np.array([4.54, 16.65, 29.42]),
        (0, 3, 0): np.array([0.0, 20.99, 29.95]),
        (1, 0, 2): np.array([6.66, 10.19, 21.96]),
        (1, 1, 1): np.array([3.52, 12.25, 26.32]),
        (1, 2, 0): np.array([0.0, 15.29, 28.82]),
        (2, 0, 1): np.array([3.59, 10.0, 20.0]),
        (2, 1, 0): np.array([0.0, 10.52, 23.19]),
        (3, 0, 0): np.array([0.0, 10.19, 18.04])
        },
    10 : {
        (0, 0, 3): np.array([10.0, 11.81, 25.74]),
        (0, 1, 2): np.array([7.25, 14.0, 28.0]),
        (0, 2, 1): np.array([4.54, 16.65, 29.42]),
        (0, 3, 0): np.array([0.0, 20.99, 29.95]),
        (1, 0, 2): np.array([10.0, 16.34, 29.3]),
        (1, 1, 1): np.array([6.67, 20.0, 30.0]),
        (1, 2, 0): np.array([2.98, 21.96, 29.81]),
        (2, 0, 1): np.array([10.0, 21.08, 29.94]),
        (2, 1, 0): np.array([6.48, 23.14, 29.5]),
        (3, 0, 0): np.array([10.0, 24.67, 28.84])
        }, 


}

# Reflect the patches across the YZ-plane
patches1 = {
        1: {
        (0, 0, 3): np.array([0.0, 20.99, 29.95]),
        (0, 1, 2): np.array([2.98, 21.96, 29.81]),
        (0, 2, 1): np.array([6.48, 23.14, 29.5]),
        (0, 3, 0): np.array([10.0, 24.67, 28.84]),
        (1, 0, 2): np.array([0.0, 23.77, 29.26]),
        (1, 1, 1): np.array([3.27, 25.1, 28.6]),
        (1, 2, 0): np.array([6.39, 26.57, 27.54]),
        (2, 0, 1): np.array([0.0, 26.53, 27.57]),
        (2, 1, 0): np.array([3.19, 27.58, 26.52]),
        (3, 0, 0): np.array([0.0, 28.33, 25.54])
        }
,
    2: {
        (0, 0, 3): np.array([10.0, 29.81, 21.96]),
        (0, 1, 2): np.array([10.0, 29.0, 24.36]),
        (0, 2, 1): np.array([10.0, 27.34, 26.8]),
        (0, 3, 0): np.array([10.0, 24.67, 28.84]),
        (1, 0, 2): np.array([6.67, 29.58, 22.85]),
        (1, 1, 1): np.array([6.8, 28.28, 25.61]),
        (1, 2, 0): np.array([6.39, 26.57, 27.54]),
        (2, 0, 1): np.array([3.26, 29.13, 24.09]),
        (2, 1, 0): np.array([3.19, 27.58, 26.52]),
        (3, 0, 0): np.array([0.0, 28.33, 25.54])
        },
    3: {
        (0, 0, 3): np.array([10.0, 29.81, 21.96]),  # M
        (0, 1, 2): np.array([6.65, 29.75, 20.4]),  # T
        (0, 2, 1): np.array([3.29, 29.69, 19.84]),  # V ###
        (0, 3, 0): np.array([0.9, 29.63, 18.7]),  # S ######
        (1, 0, 2): np.array([6.67, 29.58, 22.85]),  # Q
        (1, 1, 1): np.array([3.35, 29.81, 21.96]),  # U
        (1, 2, 0): np.array([0.0, 29.99, 21.47]),  # Z ###
        (2, 0, 1): np.array([3.26, 29.13, 24.09]),  # R
        (2, 1, 0): np.array([0.0, 29.48, 23.18]),  # W
        (3, 0, 0): np.array([0.0, 28.33, 25.54]),  # E
        },

    9: {
        (0, 0, 3): np.array([10.0, 11.81, 25.74]),
        (0, 1, 2): np.array([7.25, 14.0, 28.0]),
        (0, 2, 1): np.array([4.54, 16.65, 29.42]),
        (0, 3, 0): np.array([0.0, 20.99, 29.95]),
        (1, 0, 2): np.array([6.66, 10.19, 21.96]),
        (1, 1, 1): np.array([3.52, 12.25, 26.32]),
        (1, 2, 0): np.array([0.0, 15.29, 28.82]),
        (2, 0, 1): np.array([3.59, 10.0, 20.0]),
        (2, 1, 0): np.array([0.0, 10.52, 23.19]),
        (3, 0, 0): np.array([0.0, 10.19, 18.04])
        },
    10 : {
        (0, 0, 3): np.array([10.0, 11.81, 25.74]),
        (0, 1, 2): np.array([7.25, 14.0, 28.0]),
        (0, 2, 1): np.array([4.54, 16.65, 29.42]),
        (0, 3, 0): np.array([0.0, 20.99, 29.95]),
        (1, 0, 2): np.array([10.0, 16.34, 29.3]),
        (1, 1, 1): np.array([6.67, 20.0, 30.0]),
        (1, 2, 0): np.array([2.98, 21.96, 29.81]),
        (2, 0, 1): np.array([10.0, 21.08, 29.94]),
        (2, 1, 0): np.array([6.48, 23.14, 29.5]),
        (3, 0, 0): np.array([10.0, 24.67, 28.84])
        }, 
    11: reflect_across_YZ(patches[1]),
    21: reflect_across_YZ(patches[2]),
    31: reflect_across_YZ(patches[3]),
    91: reflect_across_YZ(patches[9]),
    101: reflect_across_YZ(patches[10]),
    
}


shared_edges_extremities = {
    (1, 2): {
        'initial': [(0, 3, 0),(1,2,0),(2,1,0),(3, 0, 0)],
        'adjacent': [(0, 3, 0),(1,2,0),(2,1,0),(3, 0, 0)],
    },
    (2,3): {
        'initial': [(3, 0, 0),(2,0,1),(1,0,2),(0, 0, 3)],
        'adjacent': [(3, 0, 0),(2,0,1),(1,0,2),(0, 0, 3)],
    },
    (9, 10): {
    'initial': [(0, 0, 3),(0,1,2),(0,2,1),(0, 3, 0)],
    'adjacent': [(0, 0, 3),(0,1,2),(0,2,1),(0, 3, 0)],
    },



    # Add mappings for other shared edges between other patches as needed
}


adjust_control_points_for_C1(patches, (1, 2), shared_edges_extremities)
adjust_control_points_for_C1(patches, (2, 3), shared_edges_extremities)
adjust_control_points_for_C1(patches, (9, 10), shared_edges_extremities)
adjust_control_points_for_C1(patches, (10, 1), shared_edges_extremities)

# Calculate points on the Bézier triangle
num_samples = 20

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

# Visualization of the control points of each patch
# Create a 3D plot
fig = plt.figure(figsize=(10, 8))
ax = fig.add_subplot(111, projection='3d')

# Plot each patch with its points in a unique color
for patch_id, patch_points in patches.items():
    xs = [point[0] for point in patch_points.values()]
    ys = [point[1] for point in patch_points.values()]
    zs = [point[2] for point in patch_points.values()]
    ax.scatter(xs, ys, zs, color=get_color(patch_id), label=f'Patch {patch_id}')

# Labeling the axes
ax.set_xlabel('X Axis')
ax.set_ylabel('Y Axis')
ax.set_zlabel('Z Axis')
ax.set_title('Points of control for Bézier Surfaces with Multiple Patches')

ax.legend()

plt.show()


# Visualization with color mapping 

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Plot Bézier surfaces for each patch with cycling colors
for patch_id, bezier_points in enumerate(all_bezier_points, start=1):
    color = get_color(patch_id-1)
    ax.plot_trisurf(bezier_points[:, 0], bezier_points[:, 1], bezier_points[:, 2], color=color, alpha=0.6)

# Optional: Plot control points for each patch with labels
for patch_id, control_points in patches.items():
    color = get_color(patch_id-1)
    for index, point in control_points.items():
        ax.scatter(*point, color=color, s=50)
        label = f'Patch {patch_id}: c{index}'
        ax.text(*point, label, size=6, zorder=1, color=color)

# Setting labels and adjusting plot
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.set_title('Bézier Surfaces with Multiple Patches')

plt.show()


## Without color mapping 

fig = plt.figure()
ax = fig.add_subplot(111, projection='3d')

# Define a single color for all patches
patch_color = 'blue'

# Plot Bézier surfaces for each patch
for bezier_points in all_bezier_points:
    ax.plot_trisurf(bezier_points[:, 0], bezier_points[:, 1], bezier_points[:, 2], color=patch_color, alpha=0.6)

# Plot control points for each patch in red without labels
control_point_color = 'red'
for control_points in patches.values():
    for point in control_points.values():
        ax.scatter(*point, color=control_point_color, s=50)

# Set labels for the axes
ax.set_xlabel('X')
ax.set_ylabel('Y')
ax.set_zlabel('Z')
ax.set_title('Without color mapping Bézier Surfaces with Multiple Patches')

plt.show()