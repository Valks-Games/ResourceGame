extends KinematicBody2D

onready var buildzone_sprite = preload("res://Sprites/build_zone.png")
onready var wood_generator_sprite = preload("res://Sprites/wood_generator.png")
onready var resources = get_tree().get_nodes_in_group("Resources")[0]
onready var world_generator = get_tree().get_nodes_in_group("WorldGenerator")[0]

var placed = false
var is_wood_gen = false
var wood = 0
var wood_timer = 0
var wood_timer_max = 1

func _ready():
	add_to_group("BuildZones")
	
func evolve():
	buildzone_sprite = wood_generator_sprite
	is_wood_gen = true
	self.get_node("Sprite").texture = wood_generator_sprite
	
func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var x = round(get_global_mouse_position().x / world_generator.cell_size)
			var y = round(get_global_mouse_position().y / world_generator.cell_size)
			if world_generator.matrix[x][y] == null:
				placed = true
				world_generator.matrix[x][y] = self
		if event.button_index == BUTTON_RIGHT and event.pressed:
			if !placed:
				queue_free()
	
func _process(delta):
	if !placed:
		var x = round(get_global_mouse_position().x / world_generator.cell_size)
		var y = round(get_global_mouse_position().y / world_generator.cell_size)
		if world_generator.matrix[x][y] == null:
			position = Vector2(x * world_generator.cell_size, y * world_generator.cell_size)
			modulate = Color(modulate.r, modulate.g, modulate.b, 0.3)
	else:
		modulate = Color(modulate.r, modulate.g, modulate.b, 1)
	if is_wood_gen:
		wood_timer += delta
		if (wood_timer >= wood_timer_max):
			wood_timer = 0
			resources.wood += 1
			get_tree().call_group("Labels", "refresh")