extends KinematicBody2D

onready var speed = 3
onready var velocity = Vector2()

func _physics_process(delta):
	if Input.is_action_pressed("left"):
		velocity.x -= speed
	if Input.is_action_pressed("right"):
		velocity.x += speed
	if Input.is_action_pressed("up"):
		velocity.y -= speed
	if Input.is_action_pressed("down"):
		velocity.y += speed
		
	move_and_slide(velocity)