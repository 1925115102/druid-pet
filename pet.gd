extends Node2D

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var area: Area2D = $Area2D

var states = ["smile", "happy", "sad"]
var is_reacting := false

# 拖动相关
var dragging := false
var drag_mouse_start := Vector2i.ZERO
var drag_window_start := Vector2i.ZERO

func _ready():
	sprite.play("normal")
	area.input_event.connect(_on_area_input_event)
	random_idle_loop()

func _on_area_input_event(_viewport, event, _shape_idx):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			start_drag()
			play_random_reaction()
		else:
			stop_drag()

func start_drag():
	dragging = true
	drag_mouse_start = DisplayServer.mouse_get_position()
	drag_window_start = DisplayServer.window_get_position()

func stop_drag():
	dragging = false

func _process(_delta):
	if dragging:
		var mouse_now = DisplayServer.mouse_get_position()
		var delta = mouse_now - drag_mouse_start
		DisplayServer.window_set_position(drag_window_start + delta)

func play_random_reaction():
	if is_reacting:
		return

	is_reacting = true
	var random_state = states[randi() % states.size()]
	sprite.play(random_state)

	await get_tree().create_timer(1.0).timeout
	sprite.play("normal")
	is_reacting = false

func random_idle_loop():
	while true:
		await get_tree().create_timer(randf_range(3.0, 6.0)).timeout

		if not is_reacting:
			var random_state = states[randi() % states.size()]
			sprite.play(random_state)

			await get_tree().create_timer(0.8).timeout
			sprite.play("normal")
