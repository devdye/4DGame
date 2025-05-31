class_name Intersect4D

func get_tetrahedron_intersect(hyperplane: Subspace3D, p1: Vector4, p2: Vector4, p3: Vector4, p4: Vector4) -> Array:
	var segments = get_tetrahedron_segments(p1, p2, p3, p4)
	
	var hits = []
	for seg in segments:
		var p = get_intersect(hyperplane, seg[0], seg[1])
		if p != null: hits.append(p)
	
	var unique = []
	for p in hits: 
		if not unique.any(func(q): return q.distance_to(p) < 1e-5): 
			unique.append(p)
	
	return unique

func vec4_to_3(vector: Vector4):
	return Vector3(vector.x, vector.y, vector.z)

func get_intersect(hyperplane: Subspace3D, a: Vector4, b: Vector4):
	var n: Vector4 = hyperplane.get_normal()
	var denom: float = n.dot(b - a)
	
	if abs(denom) == 0: return null                    
	
	var t: float = -n.dot(a) / denom
	var inter: Vector4 = (1 - t) * a + t * b
	
	return vec4_to_3(inter) if (t >= 0.0 and t <= 1.0) else null

func get_tetrahedron_segments(p1: Vector4, p2: Vector4, p3: Vector4, p4: Vector4) -> Array:
	return [[p2, p1], [p4, p1], [p2, p4], [p3, p1], [p3, p4], [p3, p2]]
	
