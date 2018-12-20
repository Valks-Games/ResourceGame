extends KinematicBody2D

const Utils = preload("res://Scripts/Utils.gd")

onready var mining_sprite = preload("res://Sprites/worker_mining.png")
onready var base_sprite = preload("res://Sprites/worker_return_to_base.png")
onready var tree_sprite = preload("res://Sprites/tree.png")
onready var townhall_sprite = preload("res://Sprites/townhall.png")
onready var worker_sprite = preload("res://Sprites/worker_mining.png")
onready var buildzone_sprite = preload("res://Sprites/build_zone.png")
onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var units = get_parent()

var velocity = Vector2();
var speed = 30
var find_resources = true
var harvest_resource_timer = 0
var harvest_time = 0.5
var dump_resource_timer = 0
var dump_resource_time_length = 0.5
var nearest_target = null
var nearest_townhall = null
var wood = 0
var tex_width
var target = null
var command = "idle"

func _ready():
	add_to_group("Workers")
	units.find_job()
	tex_width = get_node("WorkerSprite").texture.get_width()
	
func move(delta):
	var workers = get_tree().get_nodes_in_group("Workers")
	position += units.flocking_behaviour(workers, position, tex_width, target, speed) * delta * speed

func find_target(targets):
	target = Utils.find_nearest_target(position, targets)

func _physics_process(delta):
	match(command):
		"idle":
			pass
		"find_target":
			find_target(targets)