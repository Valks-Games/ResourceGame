extends Area2D

const Utils = preload("res://Scripts/Utils.gd")

onready var miningTex = preload("res://Sprites/worker_mining.png")
onready var baseTex = preload("res://Sprites/worker_return_to_base.png")

onready var velocity = Vector2();

onready var tree = get_parent().get_node("Tree")
onready var treeSprite = tree.get_node("TreeSprite")

onready var townhall = get_parent().get_node("Townhall")
onready var townhallSprite = townhall.get_node("TownhallSprite")

onready var speed = 30
onready var findResources = true

onready var harvestResourceTimer = 0
onready var harvestTime = 0.5

onready var dumpResourceTimer = 0
onready var dumpResourceTimeLength = 0.5

onready var worker = load("res://Scenes/Worker.tscn")
onready var workerSprite = get_node("WorkerSprite")

#woodcutter
#farmer
#scholar
#hunter
#miner

func _ready():
	add_to_group("Workers")
	
func harvest_resources(delta):
	# Harvest resources for 'harvestTime' seconds.
	harvestResourceTimer += 1 * delta
	if workerSprite.texture != miningTex:
		workerSprite.texture = miningTex
	if harvestResourceTimer >= harvestTime:
		harvestResourceTimer = 0
		# We are finished gathering all the resources we can carry.
		findResources = false
		
func drop_off_resources(delta):
	# Dump resources into base.
	dumpResourceTimer += 1 * delta
	if workerSprite.texture != baseTex:
		workerSprite.texture = baseTex
	if dumpResourceTimer >= dumpResourceTimeLength:
		# Resume previous task.
		dumpResourceTimer = 0
		findResources = true
		townhall.addWood(1)
		if (get_tree().get_nodes_in_group("Workers").size() < townhall.max_workers):
			get_parent().add_child(worker.instance())
	
func ai(delta):
	velocity = Vector2() # Reset the vector every frame
	
	# Search for nearest resource.
	if findResources:
		if position.distance_to(tree.position) < treeSprite.texture.get_width() + 1:
			harvest_resources(delta)
		else:
			# Find the nearest tree and move towards it.
			velocity += Utils.calc_target_velocity(position, tree.position, speed)
	else:
		# We are coming back to base with resources.
		if position.distance_to(townhall.position) < townhallSprite.texture.get_width() + 1:
			drop_off_resources(delta)
		else:
			# Move to nearest townhall.
			velocity += Utils.calc_target_velocity(position, townhall.position, speed)

func _physics_process(delta):
	ai(delta)
	position += velocity * delta