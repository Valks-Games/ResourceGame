extends Node

onready var world_width = 3000
onready var world_height = 3000
onready var tree_resource = preload("res://Scenes/Tree.tscn")

func _ready():
	randomize()
	for i in range(500):
		var tree = tree_resource.instance()
		tree.set_position(Vector2(-world_width + randi() % (world_width * 2), -world_height + randi() % (world_height * 2)))
		get_parent().call_deferred("add_child", tree)