extends Button

onready var resources = get_parent().get_parent().get_parent().get_node("World/Resources")
onready var worker = load("res://Scenes/Worker.tscn")
onready var label = get_parent().get_node("Label")

func _on_Button_pressed():
	if (resources.workers < resources.max_workers):
			var instance = worker.instance()
			instance.set_position(Vector2(0, 0))
			get_parent().get_parent().get_parent().add_child(instance)
			label.refresh()

func _process(delta):
	if resources.workers < resources.max_workers:
		disabled = false
	else:
		disabled = true