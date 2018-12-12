extends Button

onready var resources = get_parent().get_parent().get_parent().get_node("World/Resources")
onready var build_zone_sprite = preload("res://Scenes/BuildZone.tscn")
onready var player = get_parent().get_parent().get_parent().get_node("Player")
onready var label = get_parent().get_node("Label")

func _ready():
	disabled = true

func _on_Button2_pressed():
	var build_zone = build_zone_sprite.instance()
	build_zone.set_position(player.position)
	get_parent().get_parent().get_parent().add_child(build_zone)
	label.refresh()

func _process(delta):
	if resources.wood >= 10:
		disabled = false
	else:
		disabled = true
