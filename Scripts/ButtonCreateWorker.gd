extends Button

onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var world = get_tree().get_nodes_in_group("WorldGenerator")[0]
onready var units = get_tree().get_nodes_in_group("Units")[0]
onready var worker = load("res://Scenes/Worker.tscn")

func _on_Button_pressed():
	if (resources.workers < resources.max_workers):
		var instance = worker.instance()
		instance.set_position(world.get_world_coords(Vector2(world.width / 2, world.height / 2 - 1)))
		units.add_child(instance)
		get_tree().call_group("Labels", "refresh")

func _process(delta):
	if resources.workers < resources.max_workers:
		disabled = false
	else:
		disabled = true