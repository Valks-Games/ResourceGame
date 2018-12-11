extends Node2D

onready var x1
onready var y1
onready var x2
onready var y2
onready var drawing = false
onready var some_rect

func refresh():
	update()

func _draw():
	if drawing:
		var color = Color(0.1, 0.9, 0.1, 0.2)
		some_rect = Rect2(Vector2(x1, y1), Vector2(x2 - x1, y2 - y1))
		draw_rect(some_rect, color, true)
		color.a = 0.6
		draw_rect(some_rect, color, false)