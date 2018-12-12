extends KinematicBody2D

onready var buildzone_sprite = preload("res://Sprites/build_zone.png")
onready var wood_generator_sprite = preload("res://Sprites/wood_generator.png")
onready var resources = get_tree().get_nodes_in_group("Resources")[0]

var is_wood_gen = false
var wood = 0
var wood_timer = 0
var wood_timer_max = 1

func _ready():
	add_to_group("BuildZones")
	
func evolve():
	buildzone_sprite = wood_generator_sprite
	is_wood_gen = true
	self.get_node("Sprite").texture = wood_generator_sprite
	
func _process(delta):
	if is_wood_gen:
		wood_timer += delta
		if (wood_timer >= wood_timer_max):
			wood_timer = 0
			resources.wood += 1