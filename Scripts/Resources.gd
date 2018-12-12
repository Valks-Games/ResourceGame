extends Node

onready var wood = 0
onready var max_wood = 15

onready var workers = 0
onready var max_workers = 5

onready var label = get_parent().get_parent().get_node("CanvasLayer/Panel/Label")
	
func add_wood(amount):
	wood += amount
	label.refresh()