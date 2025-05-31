class_name Basis4

var i: Vector4
var j: Vector4
var k: Vector4
var l: Vector4

func _init(i_vec := Vector4(1,0,0,0), 
		   j_vec := Vector4(0,1,0,0), 
		   k_vec := Vector4(0,0,1,0), 
		   l_vec := Vector4(0,0,0,1)):
	i = i_vec
	j = j_vec
	k = k_vec
	l = l_vec

func add(m: Basis4) -> Basis4:
	return Basis4.new(
		i + m.i,
		j + m.j,
		k + m.k,
		l + m.l
	)

func sub(m: Basis4) -> Basis4:
	return Basis4.new(
		i - m.i,
		j - m.j,
		k - m.k,
		l - m.l
	)

func scalar_multiply(a: float) -> Basis4:
	return Basis4.new(
		i * a,
		j * a,
		k * a,
		l * a,
	)

func transform(p: Vector4) -> Vector4:
	return i * p.x + j * p.y + k * p.z + l * p.w

func matrix_multiply(m: Basis4) -> Basis4:
	return Basis4.new(
		transform(m.i),
		transform(m.j),
		transform(m.k),
		transform(m.l)
	)

func transpose() -> Basis4:
	return Basis4.new(
		Vector4(i.x, j.x, k.x, l.x),
		Vector4(i.y, j.y, k.y, l.y),
		Vector4(i.z, j.z, k.z, l.z),
		Vector4(i.w, j.w, k.w, l.w)
	)

func minor(r: int, c: int) -> float:
	var rows := []
	var cols := []

	for i in range(4):
		if i != r:
			rows.append(i)

	for j in range(4):
		if j != c:
			cols.append(j)
			
	return Basis(
		Vector3( self.to_array()[rows[0]][cols[0]],
			self.to_array()[rows[0]][cols[1]],
			self.to_array()[rows[0]][cols[2]] ),
		Vector3( self.to_array()[rows[1]][cols[0]],
			self.to_array()[rows[1]][cols[1]],
			self.to_array()[rows[1]][cols[2]] ),
		Vector3( self.to_array()[rows[2]][cols[0]],
			self.to_array()[rows[2]][cols[1]],
			self.to_array()[rows[2]][cols[2]] )
		).determinant()

func inverse() -> Basis4:
	var det = determinant()
	
	assert(not is_equal_approx(det, 0.0), "Basis4.inverse(): matrix is singular (determinant ≈ 0), cannot invert.")

	var cof = []
	for i in range(4):
		cof.append([])
		for j in range(4):
			var sign = 1.0 if (((i + j) % 2) == 0) else -1.0
			cof[i].append(sign * minor(i, j))

	var adj = []
	for i in range(4):
		adj.append(Vector4(cof[0][i], cof[1][i], cof[2][i], cof[3][i]))

	var inv_scale = 1.0 / det
	return Basis4.new(
		adj[0] * inv_scale,
		adj[1] * inv_scale,
		adj[2] * inv_scale,
		adj[3] * inv_scale
	)



func determinant() -> float:
	var d1 = Basis(
		Vector3(j.y, j.z, j.w),
		Vector3(k.y, k.z, k.w),
			Vector3(l.y, l.z, l.w)
	).determinant()

	var d2 = Basis(
		Vector3(j.x, j.z, j.w),
		Vector3(k.x, k.z, k.w),
		Vector3(l.x, l.z, l.w)
	).determinant()

	var d3 = Basis(
		Vector3(j.x, j.y, j.w),
		Vector3(k.x, k.y, k.w),
		Vector3(l.x, l.y, l.w)
	).determinant()

	var d4 = Basis(
		Vector3(j.x, j.y, j.z),
		Vector3(k.x, k.y, k.z),
		Vector3(l.x, l.y, l.z)
	).determinant()
	
	return i.x * d1 - i.y * d2 + i.z * d3 - i.w * d4
	
func to_array() -> Array: return [i, j, k, l]
