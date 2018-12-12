extends Label

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

onready var worker = get_parent().get_node(".")

func _ready():
	# Called when the node is added to the scene for the first time.
	# Initialization here
	pass

#func _process(delta):
#	# Called every frame. Delta is time since last frame.
#	# Update game logic here.
#	pass

func _process(delta):
	text = str(worker.wood)