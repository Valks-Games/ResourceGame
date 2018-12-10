extends KinematicBody2D

const Utils = preload("res://Scripts/Utils.gd");

var miningTex;
var baseTex;

var velocity;

var tree
var treeSprite

var townhall
var townhallSprite

var speed
var findResources

var harvestResourceTimer
var harvestTime

var dumpResourceTimer
var dumpResourceTimeLength

var worker;
var workerSprite

var workers;

func _ready():
	miningTex = preload("res://Sprites/worker_mining.png")
	baseTex = preload("res://Sprites/worker_return_to_base.png")
	
	tree = get_parent().get_node("Tree");
	treeSprite = tree.get_node("TreeSprite")
	
	townhall = get_parent().get_node("Townhall")
	townhallSprite = townhall.get_node("TownhallSprite")
	
	add_to_group("Workers")
	
	#set_physics_process(true);
	speed = 30
	findResources = true
	harvestResourceTimer = 0
	harvestTime = 0.5
	dumpResourceTimer = 0
	dumpResourceTimeLength = 0.5
	worker = load("res://Scenes/Worker.tscn")
	
	workerSprite = get_node("WorkerSprite")
	
	workers = Array()
	velocity = Vector2()
	
func _init():
	pass
	
func ai(delta):
	velocity = Vector2()
	
	# Search for nearest resource.
	if findResources:
		if position.distance_to(tree.position) < treeSprite.texture.get_width() + 1:
			# Harvest resources for 'harvestTime' seconds.
			harvestResourceTimer += 1 * delta
			workerSprite.texture = miningTex
			if harvestResourceTimer >= harvestTime:
				harvestResourceTimer = 0
				# We are finished gathering all the resources we can carry.
				findResources = false
		else:
			# Find the nearest tree and move towards it.
			velocity += Utils.calc_target_velocity(position, tree.position, speed);
	else:
		# We are coming back to base with resources.
		if position.distance_to(townhall.position) < townhallSprite.texture.get_width() + 1:
			# Dump resources into base.
			dumpResourceTimer += 1 * delta
			workerSprite.texture = baseTex
			if dumpResourceTimer >= dumpResourceTimeLength:
				# Resume previous task.
				dumpResourceTimer = 0
				findResources = true
				townhall.addWood(1)
				get_parent().add_child(worker.instance())
		else:
			# Move to nearest townhall.
			velocity += Utils.calc_target_velocity(position, townhall.position, speed);

func _physics_process(delta):
	ai(delta)
	
	move_and_slide(velocity)