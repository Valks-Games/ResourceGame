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
				circle.drawing = false
			else: #released
				circle.drawing = true
				if rect.drawing:
					var workers = get_tree().get_nodes_in_group("Workers")
					for worker in workers:
						var wpos = worker.position;
						if rect.x1 > rect.x2:
							if wpos.x >= rect.x2 && wpos.y >= rect.y2 && wpos.x <= rect.x1 && wpos.y <= rect.y1:
								if !circle.workers.has(worker):
									circle.workers.push_front(worker)
						else:
							if wpos.x >= rect.x1 && wpos.y >= rect.y1 && wpos.x <= rect.x2 && wpos.y <= rect.y2:
								if !circle.workers.has(worker):
									circle.workers.push_front(worker)
				rect.drawing = false
	elif event is InputEventMouseMotion:
		rect.x2 = get_global_mouse_position().x
		rect.y2 = get_global_mouse_position().y
		rect.refresh()

func _process(delta):
	circle.refresh()