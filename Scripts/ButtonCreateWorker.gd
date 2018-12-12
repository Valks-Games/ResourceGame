extends Button

onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var world_generator = get_tree().get_nodes_in_group("WorldGenerator")[0]
onready var worker = load("res://Scenes/Worker.tscn")

func _on_Button_pressed():
	if (resources.workers < resources.max_workers):
		var instance = worker.instance()
		instance.set_position(Vector2((world_generator.world_width / 2) * world_generator.cell_size, (world_generator.world_height / 2 - 1) * world_generator.cell_size))
		world_generator.add_child(instance)
		get_tree().call_group("Labels", "refresh")

func _process(delta):
	if resources.workers < resources.max_workers:
		disabled = false
	else:
		disabled = true