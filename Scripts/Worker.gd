extends KinematicBody2D

const Utils = preload("res://Scripts/Utils.gd")

onready var miningTex = preload("res://Sprites/worker_mining.png")
onready var baseTex = preload("res://Sprites/worker_return_to_base.png")

onready var velocity = Vector2();

onready var tree_resource = preload("res://Sprites/tree.png")
onready var townhall_resource = preload("res://Sprites/townhall.png")
onready var worker_resource = preload("res://Sprites/worker_mining.png")
onready var buildzone_resource = preload("res://Sprites/build_zone.png")

onready var speed = 30
onready var findResources = true

onready var harvestResourceTimer = 0
onready var harvestTime = 0.5

onready var dumpResourceTimer = 0
onready var dumpResourceTimeLength = 0.5

onready var nearest_target = null
onready var nearest_townhall = null
onready var command = "find_nearest_tree"

onready var wood = 0

onready var resources = get_parent().get_node("World/Resources")

#woodcutter
#farmer
#scholar
#hunter
#miner

func _ready():
	add_to_group("Workers")
	
func move(delta):
	velocity += Utils.calc_target_velocity(position, nearest_target.position, speed)
	position += velocity * delta
	velocity = Vector2()
	
func ai(delta, cmd):
	match(cmd):
		"idle":
			pass
		"find_nearest_tree":
			var trees = get_tree().get_nodes_in_group("Trees")
			nearest_target = Utils.find_nearest_target(position, trees)
			if nearest_target != null:
				command = "move_towards_nearest_tree"
		"find_nearest_townhall":
			var townhalls = get_tree().get_nodes_in_group("Townhall")
			nearest_target = Utils.find_nearest_target(position, townhalls)
			if nearest_target != null:
				command = "move_towards_nearest_townhall"
		"find_nearest_buildzone":
			var buildzones = get_tree().get_nodes_in_group("BuildZones")
			nearest_target = Utils.find_nearest_target(position, buildzones)
			if nearest_target != null:
				if wood < 1:
					resources.add_wood(-1)
					wood += 1
				command = "move_towards_nearest_buildzone"
		"move_towards_nearest_buildzone":
			if position.distance_to(nearest_target.position) < buildzone_resource.get_width() + 1:
				wood -= 1
				command = "find_nearest_townhall"
			else:
				move(delta)
		"move_towards_nearest_tree":
			if position.distance_to(nearest_target.position) < tree_resource.get_width() + 1:
				command = "harvest_wood"
			else:
				move(delta)
		"move_towards_nearest_townhall":
			if position.distance_to(nearest_target.position) < townhall_resource.get_width() + 1:
				command = "drop_off_resources"
			else:
				move(delta)
		"harvest_wood":
			# Harvest resources for 'harvestTime' seconds.
			harvestResourceTimer += 1 * delta
			if worker_resource != miningTex:
				worker_resource = miningTex
			if harvestResourceTimer >= harvestTime:
				# We are finished gathering all the resources we can carry.
				harvestResourceTimer = 0
				wood += 1
				findResources = false
				command = "find_nearest_townhall"
		"drop_off_resources":
			# Dump resources into base.
			dumpResourceTimer += 1 * delta
			if worker_resource != baseTex:
				worker_resource = baseTex
			if dumpResourceTimer >= dumpResourceTimeLength:
				# Resume previous task.
				dumpResourceTimer = 0
				findResources = true
				if wood > 0 && resources.wood <= resources.max_wood:
					resources.add_wood(wood)
					wood -= 1
				
				if resources.wood + wood < resources.max_wood:
					command = "find_nearest_tree"
				else:
					command = "find_nearest_buildzone"

func _physics_process(delta): # Main function called every frame.
	ai(delta, command)