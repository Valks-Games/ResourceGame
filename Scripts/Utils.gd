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
	
static func find_nearest_ally(finder_position, finder_team, array):
	var nearest_distance = PositiveInfinity
	var nearest_target = null
	
	for i in range(array.size()):
		var distance = finder_position.distance_to(array[i].position)
		if distance < nearest_distance && finder_team == array[i].team:
			nearest_distance = distance
			nearest_target = array[i]
	return nearest_target
	
static func find_nearest_enemy(finder_position, finder_team, array):
	var nearest_distance = PositiveInfinity
	var nearest_target = null
	
	for i in range(array.size()):
		var distance = finder_position.distance_to(array[i].position)
		if distance < nearest_distance && finder_team != array[i].team:
			nearest_distance = distance
			nearest_target = array[i]
	return nearest_target
	
# Normalized converts vector to a length unit vector of 1 unit.
static func calc_target_velocity(mover, target, speed):
	return (target - mover).normalized() * speed