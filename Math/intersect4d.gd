class_name Intersect4D

# Retrieve all edges of the tetrahedron as line segments
func get_tetrahedron_segments(p1: Vector4, p2: Vector4, p3: Vector4, p4: Vector4) -> Array:
	return [[p2, p1], [p4, p1], [p2, p4], [p3, p1], [p3, p4], [p3, p2]]

# Computes intersection points between a tetrahedron and a hyperplane
func get_tetrahedron_intersect(hyperplane: Subspace3D, p1: Vector4, p2: Vector4, p3: Vector4, p4: Vector4) -> Array:
	var segments = get_tetrahedron_segments(p1, p2, p3, p4)
	var hits = []
	
	# For each segment, compute intersection with the hyperplane
	for seg in segments:
		var p = get_intersect(hyperplane, seg[0], seg[1])
		if p != null: hits.append(p)
	
	# If there are two or fewer intersection points, no valid polygon exists
	if len(hits) <= 2: return []
	
	# Filter out duplicate points within a small tolerance
	var unique = []
	
	for p in hits:
		if not unique.any(func(q): return q.distance_to(p) < 1e-5):
			unique.append(p)
	
	# Return the list of unique intersection points
	return unique

# Converts a 4D vector to a 3D vector by discarding the w component
func vec4_to_3(vector: Vector4):
	return Vector3(vector.x, vector.y, vector.z)

# Computes the intersection point between a line segment and a hyperplane
func get_intersect(hyperplane: Subspace3D, a: Vector4, b: Vector4):
	var n: Vector4 = hyperplane.get_normal()
	var denom: float = n.dot(b - a)
	
	# If the segment is parallel to the hyperplane, there is no intersection
	if abs(denom) == 0: return null
	
	# Compute the 4D intersection point using linear interpolation and verify if it lies within the segment
	var t: float = -n.dot(a) / denom
	if (t < 0.0 or t > 1.0): return null
	
	# Compute the 4D intersection point using linear interpolation
	var inter: Vector4 = (1 - t) * a + t * b
	
	# Return the 3D projection of the intersection 
	return vec4_to_3(inter)
