extends Node

func _ready():
	add_to_group("Units")
	
func _process(delta):
	print(get_child_count())