extends KinematicBody2D

onready var wood = 0
onready var max_workers = 3
	
func addWood(amount):
	wood += amount
