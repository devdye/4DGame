@tool
# This script extends MeshInstance3D to create and display a 4D hypercube by slicing it into tetrahedra.
# It defines a list of tetrahedra (Basis4 objects), functions to scale and rotate them in 4D space,
# computes 3D triangle faces from intersections with a 3D subspace, and builds the resulting mesh.

class_name MeshInstance4D
extends MeshInstance3D


# ------------ #
#     VARS     #
# ------------ #

# EXPORTS
# Reference to the 4D world object holding the current 3D subspace
@export var world: World4D

# Position in the 4D World
@export var position_4d := Vector4.ZERO

# Scaling factors along each 4D axis
@export var scale_4d := Vector4.ONE

# Rotations in 4D World
@export var rotation_3d_planes := Vector3.ZERO  # XY, YZ, XZ rotations
@export var rotation_4d_planes := Vector3.ZERO  # XW, YW, ZW rotations

# HELPERS
var intersect =  Intersect4D.new()

# MODEL
var tetrahedrons = [
	Basis4.new(
		Vector4(0, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(0, 1, 1, 1),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(0, 1, 1, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 1, 0, 1),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 0, 1),
		Vector4(0, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 0, 1, 1),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
		Vector4(0, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 0, 0, 0),
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 1, 0),
		Vector4(1, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 1),
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 1, 0),
		Vector4(1, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 0),
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 1, 0),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 0, 1),
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 0, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 0, 1, 1),
		Vector4(1, 0, 1, 0),
		Vector4(1, 0, 0, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 0, 0, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 0, 1, 1),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 0, 1, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(1, 0, 1, 1),
	),
	Basis4.new(
		Vector4(1, 0, 0, 1),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 0, 1),
		Vector4(1, 0, 1, 1),
	),
	Basis4.new(
		Vector4(0, 0, 1, 1),
		Vector4(0, 0, 1, 0),
		Vector4(0, 0, 0, 1),
		Vector4(1, 0, 1, 1),
	),
	Basis4.new(
		Vector4(0, 1, 0, 0),
		Vector4(1, 1, 0, 0),
		Vector4(0, 1, 1, 0),
		Vector4(0, 1, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 1),
		Vector4(1, 1, 0, 0),
		Vector4(0, 1, 1, 0),
		Vector4(0, 1, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 0),
		Vector4(1, 1, 0, 0),
		Vector4(0, 1, 1, 0),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 0, 1),
		Vector4(1, 1, 0, 0),
		Vector4(0, 1, 0, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 1, 1, 1),
		Vector4(0, 1, 1, 0),
		Vector4(0, 1, 0, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 0, 0, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 0, 1),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 0, 1),
	),
	Basis4.new(
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(1, 1, 0, 1),
	),
	Basis4.new(
		Vector4(1, 0, 0, 1),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 0, 1),
		Vector4(1, 1, 0, 1),
	),
	Basis4.new(
		Vector4(0, 1, 0, 1),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 0, 1),
		Vector4(1, 1, 0, 1),
	),
	Basis4.new(
		Vector4(0, 0, 1, 0),
		Vector4(1, 0, 1, 0),
		Vector4(0, 1, 1, 0),
		Vector4(0, 0, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 1),
		Vector4(1, 0, 1, 0),
		Vector4(0, 1, 1, 0),
		Vector4(0, 0, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 0),
		Vector4(1, 0, 1, 0),
		Vector4(0, 1, 1, 0),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 0, 1, 1),
		Vector4(1, 0, 1, 0),
		Vector4(0, 0, 1, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 1, 1, 1),
		Vector4(0, 1, 1, 0),
		Vector4(0, 0, 1, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 0, 0, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
	),
	Basis4.new(
		Vector4(1, 1, 1, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
	),
	Basis4.new(
		Vector4(1, 1, 0, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 1, 0, 0),
		Vector4(1, 1, 1, 0),
	),
	Basis4.new(
		Vector4(1, 0, 1, 0),
		Vector4(1, 0, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(1, 1, 1, 0),
	),
	Basis4.new(
		Vector4(0, 1, 1, 0),
		Vector4(0, 1, 0, 0),
		Vector4(0, 0, 1, 0),
		Vector4(1, 1, 1, 0),
	),
	Basis4.new(
		Vector4(0, 0, 0, 1),
		Vector4(1, 0, 0, 1),
		Vector4(0, 1, 0, 1),
		Vector4(0, 0, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 1, 1),
		Vector4(1, 0, 0, 1),
		Vector4(0, 1, 0, 1),
		Vector4(0, 0, 1, 1),
	),
	Basis4.new(
		Vector4(1, 1, 0, 1),
		Vector4(1, 0, 0, 1),
		Vector4(0, 1, 0, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(1, 0, 1, 1),
		Vector4(1, 0, 0, 1),
		Vector4(0, 0, 1, 1),
		Vector4(1, 1, 1, 1),
	),
	Basis4.new(
		Vector4(0, 1, 1, 1),
		Vector4(0, 1, 0, 1),
		Vector4(0, 0, 1, 1),
		Vector4(1, 1, 1, 1),
	),
]


# ---------------------- #
#     TRANSFORMATIONS    #
# ---------------------- #

# Applies a 4D translation to all tetrahedra by the specified offset
func translate_mesh(translation: Vector4) -> void:
	# Construct a translation basis where all columns are the offset vector
	var translation_matrix = Basis4.new(translation, translation, translation, translation)
	
	# Apply translation to each tetrahedron 
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(tetra.add(translation_matrix))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons

# Scales all tetrahedra by the given factors along each 4D axis
func scale_mesh(factor: Vector4) -> void:
	# Scale Matrix
	var scale_matrix = Basis4.new(
		Vector4(factor.x, 0, 0, 0),
		Vector4(0, factor.y, 0, 0),
		Vector4(0, 0, factor.z, 0),
		Vector4(0, 0, 0, factor.w),
	)
	
	# Transforms all the vertices by using the Scale Matrix
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(scale_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons

# Rotate around X axis.
func rotate_xy(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(c,  s,  0,  0),
		Vector4(-s, c,  0,  0),
		Vector4(0,  0,  1,  0),
		Vector4(0,  0,  0,  1),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around Y axis.
func rotate_yz(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(1,  0,  0,  0),
		Vector4(0,  c,  s,  0),
		Vector4(0,  -s, c,  0),
		Vector4(0,  0,  0,  1),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around Z axis.
func rotate_xz(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(c,  0,  -s, 0),
		Vector4(0,  1,  0,  0),
		Vector4(s,  0,  c,  0),
		Vector4(0,  0,  0,  1),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around XW axis.
func rotate_xw(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(c,  0,  0,  s),
		Vector4(0,  1,  0,  0),
		Vector4(0,  0,  1,  0),
		Vector4(-s, 0,  0,  c),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around YW axis.
func rotate_yw(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(1,  0,  0,  -s),
		Vector4(0,  c,  0,  0 ),
		Vector4(0,  0,  1,  0 ),
		Vector4(0,  s,  0,  c ),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around ZW axis.
func rotate_zw(angle: float):
	# Precalculate cos and sin
	var c: float = cos(angle)
	var s: float = sin(angle)
	
	# Define the 4D Rotation Matrix
	var rotation_matrix = Basis4.new(
		Vector4(1,  0,  0,  0 ),
		Vector4(0,  1,  0,  0 ),
		Vector4(0,  0,  c,  -s),
		Vector4(0,  0,  s,  c ),
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons: Array[Basis4] = []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons 

# Rotate around XY, YZ and XZ axes (3D axes).
func rotate_xy_yz_xz(rotation_angles: Vector3):
	# Precalculate cos and sin
	var c1 := cos(rotation_angles.x)
	var s1 := sin(rotation_angles.x)
	var c2 := cos(rotation_angles.y)
	var s2 := sin(rotation_angles.y)
	var c3 := cos(rotation_angles.z)
	var s3 := sin(rotation_angles.z)
	
	# Define the 4D Rotation Matrix (R = R_xy * R_yz * R_xz)
	var rotation_matrix := Basis4.new(
		Vector4(c1 * c3 - s1 * s2 * s3, c1 * s2 * s3 + c3 * s1, -c2 * s3, 0),
		Vector4(-c2 * s1, c1 * c2, s2, 0 ),
		Vector4(c1 * s3 + c3 * s1 * s2, -c1 * c3 * s2 + s1 * s3, c2 * c3, 0),
		Vector4(0, 0, 0, 1)
	)
	
	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons := []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons

# Rotate around XW, YW and ZW axes (4D axes).
func rotate_wx_wy_wz(rotation_angles: Vector3): 
	# Precalculate cos and sin
	var cX := cos(rotation_angles.x)
	var sX := sin(rotation_angles.x)
	var cY := cos(rotation_angles.y)
	var sY := sin(rotation_angles.y)
	var cZ := cos(rotation_angles.z)
	var sZ := sin(rotation_angles.z)

	# Define the 4D Rotation Matrix (R = R_zw * R_yw * R_xw)
	var rotation_matrix := Basis4.new(
		Vector4(cX + sX * sY, 0, 0, -cX * sY + sX),
		Vector4(0, cY, 0, 0),
		Vector4(cY * sX * sZ, -sY * sZ, cZ, -cX * cY * sZ),
		Vector4(-cY * cZ * sX, cZ * sY, sZ, cX * cY * cZ)
	)

	# Applies the rotation matrix to all vertices of each tetrahedron
	var new_tetrahedrons := []
	
	for tetra in tetrahedrons:
		new_tetrahedrons.append(rotation_matrix.matrix_multiply(tetra))
	
	# Update vertices
	tetrahedrons = new_tetrahedrons

# Extracts two triangles from four coplanar points by ordering them CCW
func get_triangles_from_points(points: Array) -> Array:
	# Expect exactly 4 distinct, coplanar Vector3s
	if points.size() != 4:
		return []

	# 1)  Build a 2-D basis in the plane of the quad
	
	# Define Point 0 and Normal
	var p0: Vector3 = points[0]
	var n: Vector3 = ((points[1] - p0).cross(points[2] - p0))
	
	# If those points are collinear, use a different cross
	if n.length_squared() < 1e-8:
		n = ((points[1] - p0).cross(points[3] - p0))
	
	# Normalize the plane normal
	n = n.normalized()

	# First axis in the plane and Second axis in the plane perpendicular to u
	var u = (points[1] - p0).normalized()
	var v = n.cross(u)                     

	# Project every 3-D point into that 2-D basis
	var poly_2d := []
	for p in points:
		var d = p - p0
		poly_2d.append(Vector2(d.dot(u), d.dot(v)))

	# 2)  Order the four vertices CCW around their center
	
	# Compute center of projected points
	var center := Vector2()
	for p in poly_2d:
		center += p
	center /= 4.0

	# Initialize index order
	var order := [0, 1, 2, 3]
	
	# Sort indices by angle around center
	order.sort_custom(func(a, b):
		return atan2(poly_2d[a].y - center.y, poly_2d[a].x - center.x) \
			< atan2(poly_2d[b].y - center.y, poly_2d[b].x - center.x)
	)

	# 3) Fan-triangulate: 0-1-2 and 0-2-3
	
	# Build first triangle from ordered vertices
	var tri_a := [points[order[0]], points[order[1]], points[order[2]]]
	
	# Build second triangle from ordered vertices
	var tri_b := [points[order[0]], points[order[2]], points[order[3]]]

	# If winding is inverted, swap to correct orientation
	if ((tri_a[1] - tri_a[0]).cross(tri_a[2] - tri_a[0])).dot(n) < 0.0:
		# Flip winding of each triangle
		var tmp = tri_a[1]; tri_a[1] = tri_a[2]; tri_a[2] = tmp
		tmp = tri_b[1];       tri_b[1] = tri_b[2]; tri_b[2] = tmp

	# Return the two triangles as arrays of Vector3
	return [tri_a, tri_b]

func build_vertices_and_indices(triangles: Array) -> Dictionary:
	var raw_vertices := []
	var raw_indices := []
	var idx_map := {}
	var vertex_normals := []

	for tri in triangles:
		var tris := []
		if tri.size() == 3 and tri[0] is Vector3:
			tris = [tri]
		else:
			tris = tri

		for single_tri in tris:
			assert(single_tri.size() == 3, "Each triangle must have exactly 3 vertices")

			for v in single_tri:
				if not idx_map.has(v):
					var idx = raw_vertices.size()
					raw_vertices.append(v)
					vertex_normals.append(Vector3.ZERO)
					idx_map[v] = idx
				raw_indices.append(idx_map[v])

			var A = single_tri[0]
			var B = single_tri[1]
			var C = single_tri[2]
			var AB = B - A
			var AC = C - A
			var face_normal = AB.cross(AC).normalized()

			for i in range(3):
				var vertex_index = idx_map[single_tri[i]]
				vertex_normals[vertex_index] += face_normal

	for i in range(vertex_normals.size()):
		if vertex_normals[i] != Vector3.ZERO:
			vertex_normals[i] = vertex_normals[i].normalized()

	var vertices = PackedVector3Array(raw_vertices)
	var indices = PackedInt32Array(raw_indices)
	var normals = PackedVector3Array(vertex_normals)

	return {
		"vertices": vertices,
		"indices": indices,
		"normals": normals
	}

# Creates a mesh by intersecting each tetrahedron with a hyperplane
func create_mesh():
	var raw_tris := []
	
	for tetrahedron in tetrahedrons:
		# Compute intersection polygon with the world hyperplane
		var inter = intersect.get_tetrahedron_intersect(
			world.subspace3D, tetrahedron.i, tetrahedron.j, tetrahedron.k, tetrahedron.l
		)
		
		# If intersection is a triangle, use directly
		if inter.size() == 3:
			raw_tris.append(inter)
		
		# If intersection is a quad, split into two triangles
		elif inter.size() == 4:
			var ts = get_triangles_from_points(inter)
			raw_tris.append(ts[0])
			raw_tris.append(ts[1])

	# Compute centroid of all unique vertices
	var all_vertices = []
	for tri in raw_tris:
		for v in tri:
			if not all_vertices.any(func(existing): return existing.distance_to(v) < 1e-5):
				all_vertices.append(v)
	
	var centroid = Vector3.ZERO
	for v in all_vertices:
		centroid += v
	if all_vertices.size() > 0:
		centroid /= all_vertices.size()

	# Adjust triangle winding to ensure outward normals
	for tri in raw_tris:
		var tri_center = (tri[0] + tri[1] + tri[2]) / 3.0
		var to_center = tri_center - centroid
		var AB = tri[1] - tri[0]
		var AC = tri[2] - tri[0]
		var normal = AB.cross(AC).normalized()
		if normal.dot(to_center) < 0:
			# Flip winding: swap tri[1] and tri[2]
			var temp = tri[1]
			tri[1] = tri[2]
			tri[2] = temp

	# Build vertex and index arrays from collected triangles
	var mesh_data = build_vertices_and_indices(raw_tris)

	# Construct an ArrayMesh for rendering
	var arr_mesh = ArrayMesh.new()
	var arrays := []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = mesh_data.vertices
	arrays[ArrayMesh.ARRAY_INDEX] = mesh_data.indices
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	# Assign the generated mesh to this MeshInstance
	mesh = arr_mesh

# Called when node is added to scene, sets up mesh updates
func _ready():
	assert(world, "World is missing.")
	
	# Apply Transformations
	if scale_4d != Vector4.ONE: scale_mesh(scale_4d)
	if rotation_3d_planes != Vector3.ZERO: rotate_xy_yz_xz(rotation_3d_planes)
	if rotation_4d_planes != Vector3.ZERO: rotate_wx_wy_wz(rotation_4d_planes)
	if position_4d != Vector4.ZERO: translate_mesh(position_4d)
	
	# Create the initial mesh and connect world subspace changes to mesh recreation
	create_mesh()
	world.subspace_change.connect(create_mesh)
