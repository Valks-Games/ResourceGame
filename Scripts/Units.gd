extends Node

func _ready():
	add_to_group("Units")
	
func request():
	var workers = get_children()
	for i in range(workers.size()):
		workers[i].command = "find_nearest_buildzone"
		if i > 2: return