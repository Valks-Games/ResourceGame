extends Label

onready var townhall = get_node("../../Townhall")

func _process(delta):
	text = "Wood: " + str(townhall.wood)