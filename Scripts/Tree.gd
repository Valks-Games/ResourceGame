extends KinematicBody2D

var tree_info = "I'm a tree!"
var type = "tree"

func _ready():
	add_to_group("Trees")