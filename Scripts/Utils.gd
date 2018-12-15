extends Node

const PositiveInfinity = 3.402823e+38

static func find_nearest_target(finder_position, array):
	var nearest_distance = PositiveInfinity
	var nearest_target = null
	
	for i in range(array.size()):
		var distance = finder_position.distance_to(array[i].position)
		if distance < nearest_distance:
			nearest_distance = distance
			nearest_target = array[i]
	return nearest_target
	
# Normalized converts vector to a length unit vector of 1 unit.
static func calc_target_velocity(mover, target, speed):
	return (target - mover).normalized() * speed
	
# Accepts the workers as an array and the worker position being checked and the worker sprite.
static func flocking_behaviour(workers, position, width, nearest_target, speed):
	var velocity = Vector2()
	
	var close_workers = Array()
	for i in range(workers.size()):
		if position.distance_to(workers[i].position) < width:
			close_workers.append(workers[i])
			
	var alignment = compute_alignment(close_workers)
	var cohesion = compute_cohesion(position, close_workers)
	var separation = compute_separation(position, close_workers)
	
	var allignment_weight = 1
	var cohesion_weight = 1
	var separation_weight = 2.5
	
	velocity += calc_target_velocity(position, nearest_target.position, speed)
	velocity.x += alignment.x * allignment_weight + cohesion.x * cohesion_weight + separation.x * separation_weight
	velocity.y += alignment.y * allignment_weight + cohesion.y * cohesion_weight + separation.y * separation_weight
	
	return velocity.normalized()
	
static func compute_alignment(close_workers):
	var vector = Vector2()
	for i in range(close_workers.size()):
		vector.x += close_workers[i].velocity.x
		vector.y += close_workers[i].velocity.y
	if close_workers.size() == 0:
		return vector
	else:
		vector.x /= close_workers.size()
		vector.y /= close_workers.size()
		vector.normalized()
		return vector
		
static func compute_cohesion(position, close_workers):
	var vector = Vector2()
	for i in range(close_workers.size()):
		vector.x += close_workers[i].position.x
		vector.y += close_workers[i].position.y
	if close_workers.size() == 0:
		return vector
	else:
		vector.x /= close_workers.size()
		vector.y /= close_workers.size()
		vector = Vector2(vector.x - position.x, vector.y - position.y)
		vector.normalized()
		return vector
		
static func compute_separation(position, close_workers):
	var vector = Vector2()
	for i in range(close_workers.size()):
		vector.x += close_workers[i].position.x - position.x
		vector.y += close_workers[i].position.y - position.y
	if close_workers.size() == 0:
		return vector
	else:
		vector.x /= close_workers.size()
		vector.y /= close_workers.size()
		vector.x *= -1
		vector.y *= -1
		vector.normalized()
		return vector