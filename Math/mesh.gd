# This script extends MeshInstance3D to create and display a 4D hypercube by slicing it into tetrahedra.
# It defines a list of tetrahedra (Basis4 objects), functions to scale and rotate them in 4D space,
# computes 3D triangle faces from intersections with a 3D subspace, and builds the resulting mesh.

@tool
extends MeshInstance3D


# ----------- #
#     VARS    #
# ----------- #

# Reference to the 4D world object holding the current 3D subspace
@export var world: World4D

# Position in the 4D World
@export var position_4d := Vector4(0.0, 0.0, 0.0, 0.0)

# Scaling factors along each 4D axis
@export var scale_4d := Vector4(1.0, 1.0, 1.0, 1.0)

# XY, YZ, XZ rotations
@export var rotation_3d_planes := Vector3(0.0, 0.0, 0.0)
# XW, YW, ZW rotations
@export var rotation_4d_planes := Vector3(0.0, 0.0, 0.0)

# Helpers
var intersect =  Intersect4D.new()

# Model
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
func rotate_xy_yz_xz(angle_xy: float, angle_yz: float, angle_xz: float):
	# Precalculate cos and sin
	var c1 := cos(angle_xy)
	var s1 := sin(angle_xy)
	var c2 := cos(angle_yz)
	var s2 := sin(angle_yz)
	var c3 := cos(angle_xz)
	var s3 := sin(angle_xz)
	
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
func rotate_wx_wy_wz(angle_xw: float, angle_yw: float, angle_zw: float):
	# Precalculate cos and sin
	var cX := cos(angle_xw)
	var sX := sin(angle_xw)
	var cY := cos(angle_yw)
	var sY := sin(angle_yw)
	var cZ := cos(angle_zw)
	var sZ := sin(angle_zw)

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


func get_triangles_from_points(points : Array) -> Array:
	# Expect exactly 4 distinct, coplanar Vector3s
	if points.size() != 4:
		return []

	# ------------------------------------------------------------------
	# 1) Build a 2-D basis in the plane of the quad
	# ------------------------------------------------------------------
	var p0  = points[0]
	var n   = ((points[1] - p0).cross(points[2] - p0))
	if n.length_squared() < 1e-8:
		n = ((points[1] - p0).cross(points[3] - p0))
	n = n.normalized()

	var u = (points[1] - p0).normalized()  # first in-plane axis
	var v = n.cross(u)                     # second in-plane axis

	# Project every 3-D point into that 2-D basis
	var poly_2d := []
	for p in points:
		var d = p - p0
		poly_2d.append(Vector2(d.dot(u), d.dot(v)))

	# ------------------------------------------------------------------
	# 2) Order the four vertices CCW around their centre
	# ------------------------------------------------------------------
	var centre := Vector2()
	for p in poly_2d:
		centre += p
	centre /= 4.0

	var order := [0, 1, 2, 3]
	order.sort_custom(func(a, b):
		return atan2(poly_2d[a].y - centre.y, poly_2d[a].x - centre.x) \
			< atan2(poly_2d[b].y - centre.y, poly_2d[b].x - centre.x)
	)

	# ------------------------------------------------------------------
	# 3) Fan-triangulate: 0-1-2 and 0-2-3
	# ------------------------------------------------------------------
	var tri_a := [points[order[0]], points[order[1]], points[order[2]]]
	var tri_b := [points[order[0]], points[order[2]], points[order[3]]]

	if ((tri_a[1] - tri_a[0]).cross(tri_a[2] - tri_a[0])).dot(n) < 0.0:
		# Flip winding of each triangle
		var tmp = tri_a[1]; tri_a[1] = tri_a[2]; tri_a[2] = tmp
		tmp = tri_b[1];       tri_b[1] = tri_b[2]; tri_b[2] = tmp

	return [tri_a, tri_b]


func build_vertices_and_indices(triangles: Array) -> Dictionary:
	
	var raw_vertices := []            # temporary Array of Vector3
	var raw_indices := []             # temporary Array of int
	var idx_map := {}                 # Dictionary<Vector3, int>

	for tri in triangles:
		var tris := []
		if tri.size() == 3 and tri[0] is Vector3:
			tris = [tri]
		else:
			tris = tri

		for single_tri in tris:
			assert(single_tri.size() == 3)
			for v in single_tri:
				if not idx_map.has(v):
					idx_map[v] = raw_vertices.size()
					raw_vertices.append(v)
				raw_indices.append(idx_map[v])

	# now convert to Packed arrays
	var vertices = PackedVector3Array()
	for v in raw_vertices:
		vertices.append(v)

	var indices = PackedInt32Array()
	for i in raw_indices:
		indices.append(i)

	return {
		"vertices": vertices,
		"indices": indices,
	}


func create_mesh():
	var raw_tris := []
	for tetra in tetrahedrons:
		var inter = intersect.get_tetrahedron_intersect(
			world.subspace3D, tetra.i, tetra.j, tetra.k, tetra.l
		)
		if inter.size() == 3:
			raw_tris.append(inter)
		elif inter.size() == 4:
			var ts = get_triangles_from_points(inter)
			
			raw_tris.append(ts[0])
			raw_tris.append(ts[1])

	var mesh_data = build_vertices_and_indices(raw_tris)

	var arr_mesh = ArrayMesh.new()
	var arrays := []
	arrays.resize(ArrayMesh.ARRAY_MAX)
	arrays[ArrayMesh.ARRAY_VERTEX] = mesh_data.vertices
	arrays[ArrayMesh.ARRAY_INDEX]  = mesh_data.indices
	arr_mesh.add_surface_from_arrays(Mesh.PRIMITIVE_TRIANGLES, arrays)

	mesh = arr_mesh   # if this script is on a MeshInstanc

func _ready():
	assert(world, "World is missing.")
	
	scale_mesh(scale_4d)
	
	create_mesh()
	
	world.subspace_change.connect(create_mesh)
