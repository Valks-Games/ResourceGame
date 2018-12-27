extends Node

onready var tree_resource = preload("res://Scenes/Tree.tscn")
onready var townhall_resource = preload("res://Scenes/Townhall.tscn")
onready var unit_resource = preload("res://Scenes/Unit.tscn")
onready var player_resource = preload("res://Scenes/Player.tscn")
onready var structure_resource = preload("res://Scenes/BuildZone.tscn")
onready var tile_map = get_tree().get_nodes_in_group("TileMap")[0]
onready var rock_map = get_tree().get_nodes_in_group("RockTiles")[0]

onready var townhall_sprite = preload("res://Sprites/townhall.png")

var width = 100
var height = 100
var cell_size = 32
var spawn_room = 5
var tree_chance = 10
var offset = cell_size / 2

var player

var matrix = []

func init_2d_array():
	for x in range(width):
	    matrix.append([])
	    for y in range(height):
	        matrix[x].append(null)
			
func get_world_coords(v):
	return Vector2(v.x * cell_size + offset, v.y * cell_size + offset)
	
func convert_to_world_coords(v):
	v.x = round(v.x / cell_size)
	v.y = round(v.y / cell_size)
	return Vector2(v.x, v.y)
	
func update_world_cell(v, instance):
	matrix[v.x][v.y] = instance
	
func clear_world_cell(v):
	matrix[v.x][v.y] = null
	
func world_cell_free(v):
	return matrix[v.x][v.y] == null
	
func world_gen_chance(n):
	if randi() % 100 < n:
		return true
		
func world_spawn_check(v):
	if v.x >= width / 2 + spawn_room || v.x <= width / 2 - spawn_room || v.y >= height / 2 + spawn_room || v.y <= height / 2 - spawn_room:
		return true
		
func populate_world():
	randomize()
	
	for x in range(width):
		for y in range(height):
			tile_map.set_cell(x, y, randi() % 4)
			if world_gen_chance(5): rock_map.set_cell(x, y, randi() % 2)
			if world_gen_chance(tree_chance):
				if world_spawn_check(Vector2(x, y)):
					matrix[x][y] = tree_resource.instance()
	
	var townhall = structure_resource.instance()
	townhall.placed = true
	townhall.get_node("Sprite").texture = townhall_sprite
	update_world_cell(Vector2(width / 2, height / 2), townhall)
	update_world_cell(Vector2(width / 2 + 1, height / 2), player)
	
	for x in range(width):
		for y in range(height):
			if !world_cell_free(Vector2(x, y)):
				matrix[x][y].set_position(get_world_coords(Vector2(x, y)))
				get_parent().call_deferred("add_child", matrix[x][y])
				
	# TEMPORARY
	var enemy = unit_resource.instance()
	enemy.team = "blue"
	enemy.command = "find_enemies"
	enemy.set_position(get_world_coords(Vector2(width / 2, height / 2 + 3)))
	get_node("Units").call_deferred("add_child", enemy)
	# TEMPORARY
				
	# Player moves so you should be able to build there after!
	clear_world_cell(Vector2(width / 2 + 1, height / 2))

func _ready():
	player = player_resource.instance()
	add_to_group("WorldGenerator")
	init_2d_array()
	populate_world()