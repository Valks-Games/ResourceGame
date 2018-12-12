extends Label

onready var resources = get_tree().get_nodes_in_group("Resources")[0]

var message = Array()
var final_message = ""

func _ready():
	add_to_group("Labels")
	refresh()

func refresh():
	var worker_count = get_tree().get_nodes_in_group("Workers").size()
	if worker_count == 0:
		resources.workers = 1
	else:
		resources.workers = worker_count
	
	message.push_back("Wood: " + str(resources.wood) + " / " + str(resources.max_wood))
	message.push_back("Stone: " + str(resources.stone) + " / " + str(resources.max_stone))
	message.push_back("Iron: " + str(resources.iron) + " / " + str(resources.max_iron))
	message.push_back("Workers: " + str(resources.workers) + " / " + str(resources.max_workers))
	
	for i in range(message.size()):
		final_message += message[i] + "\n"
	text = final_message
	
	message = Array()
	final_message = ""
