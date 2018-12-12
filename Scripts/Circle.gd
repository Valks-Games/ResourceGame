extends Node2D

onready var drawing = false
onready var workers = Array()

func refresh():
	update()
	
func _draw():
	for worker in workers:
		var width = worker.get_node("WorkerSprite").texture.get_width()
		draw_circle(worker.position, width / 2 + width / 8, Color(0, 1, 0, 0.5))
	if !drawing: 
		workers = Array()