class_name Subspace3D

var _u: Vector4 = Vector4(1, 0, 0, 0) # NORMALIZED
var _v: Vector4 = Vector4(0, 1, 0, 0) # NORMALIZED
var _w: Vector4 = Vector4(0, 0, 1, 0) # NORMALIZED

var _xw_angle: float = 0.0
var _yw_angle: float = 0.0
var _zw_angle: float = 0.0

func _init():
	pass

func _u_str() -> String:
	return "(" + ", ".join([str(_u.x), str(_u.y), str(_u.z), str(_u.w)]) + ")"
	
func _v_str() -> String:
	return "(" + ", ".join([str(_v.x), str(_v.y), str(_v.z), str(_v.w)]) + ")"
	
func _w_str() -> String:
	return "(" + ", ".join([str(_w.x), str(_w.y), str(_w.z), str(_w.w)]) + ")"

func _to_string() -> String:
	return "Plane : " + "\n  - ".join([_u_str(), _v_str(), _w_str()])

func set_xw_angle(angle: float) -> void:
	_xw_angle = wrapf(angle, 0.0, TAU)
	_verify_normal()
	_u = Vector4(cos(angle), 0, 0, -sin(angle))
	update_normal()

func set_yw_angle(angle: float) -> void:
	_yw_angle = wrapf(angle, 0.0, TAU)
	_verify_normal()
	_v = Vector4(0, cos(angle), 0, sin(angle))
	update_normal()

func set_zw_angle(angle: float) -> void:
	_zw_angle = wrapf(angle, 0.0, TAU)
	_verify_normal()
	_w = Vector4(0, 0, cos(angle), sin(angle))
	update_normal()

func set_angles(xw: float, yw: float, zw: float) -> void:
	_xw_angle = wrapf(xw, 0.0, TAU)
	_yw_angle = wrapf(yw, 0.0, TAU)
	_zw_angle = wrapf(zw, 0.0, TAU)
	_verify_normal()
	
	_u = Vector4(cos(_xw_angle), 0, 0, -sin(_xw_angle))
	_v = Vector4(0, cos(_yw_angle), 0, sin(_yw_angle))
	_w = Vector4(0, 0, cos(_zw_angle), sin(_zw_angle))
	
	update_normal()

func get_u() -> Vector4: return _u
func get_v() -> Vector4: return _v
func get_w() -> Vector4: return _w
func get_plane_vectors() -> Array: return [_u, _v, _w]

var _normal: Vector4 = Vector4(0, 0, 0, 1) # NORMALIZED

var f1 = PI / 2
var f2 = 3 * PI / 2

func _verify_normal():
	if _xw_angle == f1 or _xw_angle == f2: _xw_angle += 1e-10
	if _yw_angle == f1 or _yw_angle == f2: _yw_angle += 1e-10
	if _zw_angle == f1 or _zw_angle == f2: _zw_angle += 1e-10 

func update_normal() -> void:
	var divider: float = 1 + tan(_xw_angle) ** 2 + tan(_yw_angle) ** 2 + tan(_zw_angle) ** 2
	if divider == 0: return
	
	_normal = Vector4(-tan(_xw_angle), tan(_yw_angle), tan(_zw_angle), -1) * (1 / divider)

func get_4d_angles() -> Vector3: return Vector3(_xw_angle, _yw_angle, _zw_angle)
func get_xw_angle() -> float: return _xw_angle
func get_yw_angle() -> float: return _yw_angle
func get_zw_angle() -> float: return _zw_angle

func get_normal() -> Vector4: return _normal

# DEBUG 
func verify_dot_product() -> void:
	set_xw_angle(randf_range(-2 * PI, 2 * PI))
	set_yw_angle(randf_range(-2 * PI, 2 * PI))
	set_zw_angle(randf_range(-2 * PI, 2 * PI))
	
	print(_normal.dot(_u), _normal.dot(_v), _normal.dot(_w))
