extends Button

onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var build_zone_sprite = preload("res://Scenes/BuildZone.tscn")
onready var world = get_tree().get_nodes_in_group("WorldGenerator")[0]

func _ready():
	disabled = true

func _on_Button2_pressed():
	var build_zone = build_zone_sprite.instance()

	var p_pos = world.player.position
	var pos = world.convert_to_world_coords(Vector2(p_pos.x, p_pos.y))
	build_zone.set_position(world.get_world_coords(Vector2(pos.x + world.offset, pos.y + world.offset)))
	build_zone.init("house")
	world.add_child(build_zone)
	get_tree().call_group("Labels", "refresh")

func _process(delta):
	if resources.wood >= 0:
		disabled = false
	else:
		disabled = true
