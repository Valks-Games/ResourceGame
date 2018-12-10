extends KinematicBody2D

const Utils = preload("res://Scripts/Utils.gd");

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

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	tree = get_parent().get_node("Tree");
	treeSprite = tree.get_node("TreeSprite")
	
	townhall = get_parent().get_node("Townhall")
	townhallSprite = townhall.get_node("TownhallSprite")
	
	add_to_group("Workers")
	
	#set_physics_process(true);
	speed = 30
	findResources = true
	harvestResourceTimer = 0
	harvestTime = 2
	dumpResourceTimer = 0
	dumpResourceTimeLength = 1
	worker = load("res://Scenes/Worker.tscn")
	
	velocity = Vector2()
	
func _init():
	pass
	
func compute_alignment():
	var vector = Vector2()
	var workers = get_tree().get_nodes_in_group("Workers")
	for my_worker in workers:
		vector.x += my_worker.velocity.x # Invalid get index 'x' (on base: 'Nil')
		vector.y += my_worker.velocity.y
	vector.x /= workers.size()
	vector.y /= workers.size()
	vector.normalized()
	return vector
	
func compute_cohesion():
	pass

func compute_separation():
	pass
		
func ai(delta):
	velocity = Vector2()
	
	# Search for nearest resource.
	if findResources:
		if position.distance_to(tree.position) < treeSprite.texture.get_width() + 1:
			# Harvest resources for 'harvestTime' seconds.
			harvestResourceTimer += 1 * delta
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
			if dumpResourceTimer >= dumpResourceTimeLength:
				# Resume previous task.
				dumpResourceTimer = 0
				findResources = true
				get_parent().add_child(worker.instance())
		else:
			# Move to nearest townhall.
			velocity += Utils.calc_target_velocity(position, townhall.position, speed);

func _physics_process(delta):
	ai(delta)
	move_and_slide(velocity)
	print(compute_alignment())