class_name Basis4


# ------------ #
#     VARS     #
# ------------ #

# 4x4 matrix representation using four Vector4 columns
var i: Vector4
var j: Vector4
var k: Vector4
var l: Vector4


# ----------------------- #
#     CLASS FUNCTIONS     #
# ----------------------- #

# Initialize Basis4 with optional column vectors
func _init(i_vec := Vector4(1,0,0,0), 
		   j_vec := Vector4(0,1,0,0), 
		   k_vec := Vector4(0,0,1,0), 
		   l_vec := Vector4(0,0,0,1)):
	# Assign each column vector
	i = i_vec
	j = j_vec
	k = k_vec
	l = l_vec
	
# Add another Basis4 to this one component-wise
func add(m: Basis4) -> Basis4:
	return Basis4.new(
		i + m.i,
		j + m.j,
		k + m.k,
		l + m.l
	)

# Subtract another Basis4 from this one component-wise
func sub(m: Basis4) -> Basis4:
	return Basis4.new(
		i - m.i,
		j - m.j,
		k - m.k,
		l - m.l
	)

# Multiply each column vector by a scalar
func scalar_multiply(a: float) -> Basis4:
	return Basis4.new(
		i * a,
		j * a,
		k * a,
		l * a
	)

# Transform a 4D point by this Basis4 matrix
func transform(p: Vector4) -> Vector4:
	return i * p.x + j * p.y + k * p.z + l * p.w

# Multiply this Basis4 by another Basis4 (matrix multiplication)
func matrix_multiply(m: Basis4) -> Basis4:
	# Transform each column of the other matrix
	return Basis4.new(
		transform(m.i),
		transform(m.j),
		transform(m.k),
		transform(m.l)
	)

# Transpose the matrix by swapping rows and columns
func transpose() -> Basis4:
	return Basis4.new(
		Vector4(i.x, j.x, k.x, l.x),
		Vector4(i.y, j.y, k.y, l.y),
		Vector4(i.z, j.z, k.z, l.z),
		Vector4(i.w, j.w, k.w, l.w)
	)

# Compute the minor determinant of the 4x4 matrix excluding row r and column c
func minor(r: int, c: int) -> float:
	# Collect row indices except r
	var rows := []
	for i in range(4):
		if i != r:
			rows.append(i)

	# Collect column indices except c
	var cols := []
	for j in range(4):
		if j != c:
			cols.append(j)
			
	# Build a 3x3 submatrix and return its determinant
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

# Compute the inverse of the matrix using cofactor and adjugate
func inverse() -> Basis4:
	# Compute determinant of this matrix
	var det = determinant()
	
	# Ensure the matrix is not singular
	assert(not is_equal_approx(det, 0.0), "Basis4.inverse(): matrix is singular (determinant ≈ 0), cannot invert.")

	# Compute cofactor matrix
	var cof = []
	for i in range(4):
		cof.append([])
		for j in range(4):
			# Determine sign based on position
			var sign = 1.0 if (((i + j) % 2) == 0) else -1.0
			cof[i].append(sign * minor(i, j))

	# Build adjugate by transposing cofactor matrix
	var adj = []
	for i in range(4):
		adj.append(Vector4(cof[0][i], cof[1][i], cof[2][i], cof[3][i]))

	# Scale adjugate by 1/det to get inverse
	var inv_scale = 1.0 / det
	return Basis4.new(
		adj[0] * inv_scale,
		adj[1] * inv_scale,
		adj[2] * inv_scale,
		adj[3] * inv_scale
	)

# Compute the determinant of the 4x4 matrix by expanding along the first column
func determinant() -> float:
	# Compute 3x3 determinants for each minor
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
	
	# Combine with signs to compute full determinant
	return i.x * d1 - i.y * d2 + i.z * d3 - i.w * d4
	
# Convert this Basis4 into a 2D Array of Vector4 columns
func to_array() -> Array:
	return [i, j, k, l]

# Convert this Basis4 into a String
func _to_string() -> String:
	return "Basis4([" + ", ".join([str(i), str(j), str(k), str(l)]) + "])"
