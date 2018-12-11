extends Area2D

onready var wood = 0
onready var max_workers = 3

onready var label = get_parent().get_node("CanvasLayer/Panel/Label")
	
func addWood(amount):
	wood += amount
	label.refresh()
	
func _ready():
	add_to_group("Obstacles")
