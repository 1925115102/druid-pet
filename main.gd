extends Node2D

var dragging := false
var drag_mouse_start := Vector2i.ZERO
var drag_window_start := Vector2i.ZERO

func _ready():
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_BORDERLESS, true)
	DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_ALWAYS_ON_TOP, true)

	if DisplayServer.is_window_transparency_available():
		DisplayServer.window_set_flag(DisplayServer.WINDOW_FLAG_TRANSPARENT, true)
	else:
		print("Window transparency is not available on this system.")

func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			dragging = true
			drag_mouse_start = DisplayServer.mouse_get_position()
			drag_window_start = DisplayServer.window_get_position()
		else:
			dragging = false

func _process(_delta):
	if dragging:
		var mouse_now = DisplayServer.mouse_get_position()
		var delta = mouse_now - drag_mouse_start
		DisplayServer.window_set_position(drag_window_start + delta)
