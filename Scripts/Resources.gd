extends Node

var wood = 0
var max_wood = 5

var stone = 0
var max_stone = 15

var iron = 0
var max_iron = 15

var gold = 0
var max_gold = 15

var workers = 0
var max_workers = 5

func _ready():
	add_to_group("Resources")
	
func add_wood(amount):
	wood += amount
	get_tree().call_group("Labels", "refresh")