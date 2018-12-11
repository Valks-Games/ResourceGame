extends Node2D

onready var rect = get_node("Rectangle")
onready var circle = get_node("Circle")

func _input(event):
	if event is InputEventMouseButton:
		# Start rectangle
		if event.button_index == BUTTON_LEFT:
			if event.is_pressed(): #pressed
				rect.x1 = get_global_mouse_position().x
				rect.y1 = get_global_mouse_position().y
				rect.x2 = rect.x1
				rect.y2 = rect.y1
				rect.drawing = true
				circle.drawing = true
			else: #released
				rect.drawing = false
	elif event is InputEventMouseMotion:
		rect.x2 = get_global_mouse_position().x
		rect.y2 = get_global_mouse_position().y
		rect.refresh()

func _process(delta):
	circle.refresh()
	if rect.drawing and circle.drawing:
		var workers = get_tree().get_nodes_in_group("Workers")
		for worker in workers:
			if rect.rect.has_point(worker.position):
				circle.workers.push_front(worker)