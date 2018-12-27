extends KinematicBody2D

const Utils = preload("res://Scripts/Utils.gd")

onready var mining_sprite = preload("res://Sprites/worker_mining.png")
onready var base_sprite = preload("res://Sprites/worker_return_to_base.png")
onready var tree_sprite = preload("res://Sprites/tree.png")
onready var townhall_sprite = preload("res://Sprites/townhall.png")
onready var worker_sprite = preload("res://Sprites/worker_mining.png")
onready var buildzone_sprite = preload("res://Sprites/build_zone.png")
onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var tex_width = get_node("UnitSprite").texture.get_width()
onready var units = get_parent()

var velocity = Vector2()

var team
var wood
var target
var command

var chop_timer = 0.0
var chop_time = 3.0

var dump_resources_timer = 0.0
var dump_resources_time = 1.0

var health = 10

func _ready():
	add_to_group("Units")
	
	wood = 0
	target = null
	
	get_node("Label").refresh_label()
	
func move(delta):
	if position.distance_to(target.position) > tex_width:
		var speed = 30
		position += units.flocking_behaviour(get_tree().get_nodes_in_group("Workers"), position, tex_width, target.position, speed) * delta * speed

func _physics_process(delta):
	match(command):
		"idle":
			pass
		"find_tree":
			target = Utils.find_nearest_target(position, get_tree().get_nodes_in_group("Trees"))
			if target != null:
				command = "move_to_tree"
		"move_to_tree":
			if position.distance_to(target.position) > tex_width:
				move(delta)
			else:
				chop_timer += 0.1
				if chop_timer > chop_time:
					chop_timer = 0.0
					
					wood += 1 # Gather 1 wood from tree.
					get_node("Label").refresh_label()
					
					command = "find_townhall"
		"find_townhall":
			target = Utils.find_nearest_ally(position, team, get_tree().get_nodes_in_group("Structures"))
			if target != null:
				command = "move_to_townhall"
		"move_to_townhall":
			if position.distance_to(target.position) > tex_width:
				move(delta)
			else:
				dump_resources_timer += 0.1
				if dump_resources_timer > dump_resources_time:
					dump_resources_timer += 0.0
					
					drop_off_resources()
					get_node("Label").refresh_label()
					
					command = "find_tree"
		"find_enemies":
			target = Utils.find_nearest_enemy(position, team, get_tree().get_nodes_in_group("Units"))
			if target != null:
				command = "attack_enemies"
			else:
				command = "find_tree"
		"attack_enemies":
			if weakref(target).get_ref():
				if position.distance_to(target.position) > tex_width:
					move(delta)
				else:
					target.health -= 1
					if target.health <= 0:
						target.queue_free()
			else:
				command = "find_tree"

func drop_off_resources():
	if wood > 0:
		resources.add_wood(wood)
		wood = 0