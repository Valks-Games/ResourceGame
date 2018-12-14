extends Node

onready var tree_resource = preload("res://Scenes/Tree.tscn")
onready var townhall_resource = preload("res://Scenes/Townhall.tscn")
onready var worker_resource = preload("res://Scenes/Worker.tscn")
onready var player_resource = preload("res://Scenes/Player.tscn")
onready var tile_map = get_tree().get_nodes_in_group("TileMap")[0]
onready var rock_map = get_tree().get_nodes_in_group("RockTiles")[0]

var world_width = 100
var world_height = 100
var cell_size = 32
var spawn_room = 5
var tree_chance = 10

var player

var matrix = []

func init2DArray():
	for x in range(world_width):
	    matrix.append([])
	    for y in range(world_height):
	        matrix[x].append(null)

func _ready():
	player = player_resource.instance()
	
	add_to_group("WorldGenerator")
	
	init2DArray()
	
	randomize()
	
	for x in range(world_width):
		for y in range(world_height):
			tile_map.set_cell(x, y, randi() % 4)
			if randi() % 100 < 5: rock_map.set_cell(x, y, randi() % 2)
			if randi() % 100 < tree_chance:
				if x >= world_width / 2 + spawn_room || x <= world_width / 2 - spawn_room || y >= world_height / 2 + spawn_room || y <= world_height / 2 - spawn_room:
					matrix[x][y] = tree_resource.instance()
	matrix[world_width / 2][world_height / 2] = townhall_resource.instance()
	matrix[world_width / 2 + 1][world_height / 2] = player
			
	for x in range(world_width):
		for y in range(world_height):
			if matrix[x][y] != null:
				var offset = cell_size / 2
				matrix[x][y].set_position(Vector2(x * cell_size + offset, y * cell_size + offset))
				get_parent().call_deferred("add_child", matrix[x][y])
	
	# Player moves so you should be able to build there after!
	matrix[world_width / 2 + 1][world_height / 2] = null