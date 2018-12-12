extends Node2D

var x1
var x2
var y1
var y2
var drawing = false
var some_rect

func refresh():
	update()

func _draw():
	if drawing:
		var color = Color(0.1, 0.9, 0.1, 0.2)
		some_rect = Rect2(Vector2(x1, y1), Vector2(x2 - x1, y2 - y1))
		draw_rect(some_rect, color, true)
		color.a = 0.6
		draw_rect(some_rect, color, false)