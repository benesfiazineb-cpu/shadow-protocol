# Scripts/Utilities/HelperFunctions.gd

# --- Math Helpers ---
func distance_between(point_a: Vector3, point_b: Vector3) -> float:
	return point_a.distance_to(point_b)

func angle_between(from_point: Vector3, to_point: Vector3) -> float:
	return from_point.angle_to(to_point)

func is_in_range(point_a: Vector3, point_b: Vector3, range_dist: float) -> bool:
	return distance_between(point_a, point_b) <= range_dist

func lerp_clamped(from_val: float, to_val: float, weight: float) -> float:
	return lerp(from_val, to_val, clamp(weight, 0.0, 1.0))

# --- Array Helpers ---
func find_closest_node(origin: Vector3, nodes: Array[Node3D]) -> Node3D:
	var closest_node = null
	var closest_distance = INF
	
	for node in nodes:
		var dist = distance_between(origin, node.global_position)
		if dist < closest_distance:
			closest_distance = dist
			closest_node = node
	
	return closest_node

func find_nodes_in_radius(origin: Vector3, nodes: Array[Node3D], radius: float) -> Array[Node3D]:
	var nodes_in_range: Array[Node3D] = []
	
	for node in nodes:
		if is_in_range(origin, node.global_position, radius):
			nodes_in_range.append(node)
	
	return nodes_in_range

# --- String Helpers ---
func format_time(seconds: float) -> String:
	var minutes = int(seconds) / 60
	var secs = int(seconds) % 60
	return str(minutes).pad_zeros(2) + ":" + str(secs).pad_zeros(2)

func format_large_number(number: int) -> String:
	if number >= 1000000:
		return str(number / 1000000) + "M"
	elif number >= 1000:
		return str(number / 1000) + "K"
	else:
		return str(number)

# --- Random Helpers ---
func random_position_in_sphere(center: Vector3, radius: float) -> Vector3:
	var random_offset = Vector3(
		randf_range(-radius, radius),
		randf_range(-radius, radius),
		randf_range(-radius, radius)
	)
	return center + random_offset

func random_from_array(array: Array):
	if array.is_empty():
		return null
	return array[randi() % array.size()]

# --- Physics Helpers ---
func raycast_from_position(from_pos: Vector3, to_pos: Vector3, space_state: PhysicsDirectSpaceState3D):
	var query = PhysicsRayQueryParameters3D.create(from_pos, to_pos)
	return space_state.intersect_ray(query)
