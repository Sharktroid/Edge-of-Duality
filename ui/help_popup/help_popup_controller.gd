extends Control

const SPEED = 10

var _active: bool = false


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel") and is_active():
		shrink()
		accept_event()


func display_text(text: String) -> void:
	if not get_popup_node().visible:
		await _expand(text)
	get_popup_node().text = text


func shrink() -> void:
	var max_size: Vector2 = get_popup_node().custom_minimum_size
	get_popup_node().text = ""
	get_popup_node().custom_minimum_size = Vector2()
	var min_size: Vector2 = get_popup_node().get_minimum_size()
	var starting_ticks: int = Engine.get_physics_frames()
	var get_weight: Callable = func(): return float(Engine.get_physics_frames() - starting_ticks)/SPEED
	while get_weight.call() < 1:
		await get_popup_node().get_tree().process_frame
		get_popup_node().custom_minimum_size = max_size.lerp(min_size, get_weight.call())
	get_popup_node().custom_minimum_size = min_size
	get_popup_node().visible = false
	_active = false


func is_active() -> bool:
	return _active


func get_popup_node() -> Label:
	return MapController.get_node("UI Layer/Help Popup")


func _expand(text: String) -> void:
	_active = true
	var min_size: Vector2 = get_popup_node().size
	get_popup_node().text = text
	get_popup_node().visible = true
	var max_size: Vector2 = get_popup_node().size
	get_popup_node().text = ""
	var starting_ticks: int = Engine.get_physics_frames()
	var get_weight: Callable = func(): return float(Engine.get_physics_frames() - starting_ticks)/SPEED
	while get_weight.call() < 1:
		await get_popup_node().get_tree().process_frame
		get_popup_node().custom_minimum_size = min_size.lerp(max_size, get_weight.call())
	get_popup_node().custom_minimum_size = max_size