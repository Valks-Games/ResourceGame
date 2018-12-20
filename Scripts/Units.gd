extends Node

const Utils = preload("res://Scripts/Utils.gd")

onready var structures_parent = get_tree().get_nodes_in_group("Structures")[0]

func _ready():
	add_to_group("Units")
		
# Accepts the workers as an array and the worker position being checked and the worker sprite.
func flocking_behaviour(workers, pos, width, target, speed):
	var velocity = Vector2()
	
	var close_workers = Array()
	for i in range(workers.size()):
		if pos.distance_to(workers[i].position) < width:
			close_workers.append(workers[i])
			
	var alignment = compute_alignment(close_workers)
	var cohesion = compute_cohesion(pos, close_workers)
	var separation = compute_separation(pos, close_workers)
	
	var allignment_weight = 1
	var cohesion_weight = 1
	var separation_weight = 2.5 #2.5
	
	velocity += Utils.calc_target_velocity(pos, target.position, speed)
	velocity.x += alignment.x * allignment_weight + cohesion.x * cohesion_weight + separation.x * separation_weight
	velocity.y += alignment.y * allignment_weight + cohesion.y * cohesion_weight + separation.y * separation_weight
	
	return velocity.normalized()

func compute_alignment(close_workers):
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
		
func compute_cohesion(position, close_workers):
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
		
func compute_separation(position, close_workers):
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