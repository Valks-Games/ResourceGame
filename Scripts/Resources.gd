extends Node

var wood = 0
var max_wood = 15

var workers = 0
var max_workers = 5

func _ready():
	add_to_group("Resources")
	
func add_wood(amount):
	wood += amount
	get_tree().call_group("Labels", "refresh")