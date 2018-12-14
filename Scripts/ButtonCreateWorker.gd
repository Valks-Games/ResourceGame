extends Button

onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var world_generator = get_tree().get_nodes_in_group("WorldGenerator")[0]
onready var units = get_tree().get_nodes_in_group("Units")[0]
onready var worker = load("res://Scenes/Worker.tscn")

func _on_Button_pressed():
	if (resources.workers < resources.max_workers):
		var instance = worker.instance()
		var cell_size = world_generator.cell_size
		var w = world_generator.world_width
		var h = world_generator.world_height
		var offset = cell_size / 2
		instance.set_position(Vector2((w / 2) * cell_size + offset, (h / 2 - 1) * cell_size + offset))
		units.add_child(instance)
		get_tree().call_group("Labels", "refresh")

func _process(delta):
	if resources.workers < resources.max_workers:
		disabled = false
	else:
		disabled = true