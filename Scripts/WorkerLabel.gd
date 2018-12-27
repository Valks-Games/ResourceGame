extends Label

onready var worker = get_parent().get_node(".")

func refresh_label():
	text = str(worker.wood)