extends Label

onready var townhall = get_node("../../Townhall")
onready var message = Array()
onready var final_message = ""

func _process(delta):
	message.push_front("Max Workers: " + str(townhall.max_workers))
	message.push_front("Wood: " + str(townhall.wood))
	
	for i in range(message.size()):
		final_message += message[i] + "\n"
	text = final_message
	
	message = Array()
	final_message = ""