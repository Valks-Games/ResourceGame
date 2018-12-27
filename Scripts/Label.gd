extends Label

onready var resources = get_tree().get_nodes_in_group("Resources")[0]

var message = Array()
var final_message = ""

func _ready():
	add_to_group("Labels")
	refresh()

func refresh():
	var worker_count = 0
	var workers = get_tree().get_nodes_in_group("Units")
	for i in range(workers.size()):
		if workers[i].team == "red":
			worker_count += 1
	
	if worker_count == 0:
		resources.workers = 0
	else:
		resources.workers = worker_count
	
	message.push_back("Wood: " + str(resources.wood))
	message.push_back("Stone: " + str(resources.stone))
	message.push_back("Iron: " + str(resources.iron))
	message.push_back("Workers: " + str(resources.workers) + " / " + str(resources.max_workers))
	
	for i in range(message.size()):
		final_message += message[i] + "\n"
	text = final_message
	
	message = Array()
	final_message = ""
