class_name Cursor
extends Sprite2D

signal moved
signal select
signal cancel

enum icons {ATTACK}

var _icon_sprite: Sprite2D
var _rel_pos: Vector2i
var _true_origin: Vector2


func _ready() -> void:
	set_rel_pos(transform.get_origin())
	set_process_input(true)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept"):
		emit_signal("select")
	elif event.is_action_pressed("ui_cancel"):
		emit_signal("cancel")


func _process(_delta):
	var tick_timer: int = int(GenVars.get_tick_timer()) % 32
	if tick_timer <= 20:
		frame = 0
	elif tick_timer <= 22 or tick_timer > 30:
		frame = 1
	else:
		frame = 2


func _physics_process(_delta: float) -> void:
	if GenVars.get_game_controller().controller_type == "Mouse" and is_processing_input():
		var destination: Vector2 = GenVars.get_map_camera().get_destination()
		if destination == GenVars.get_map_camera().transform.get_origin():
			var mouse_position = get_viewport().get_mouse_position()
			set_rel_pos((mouse_position) - Vector2((GenVars.get_map_camera() as MapCamera).map_offset))
	else:
		var new_pos := Vector2i()
		if get_rel_pos() == (_true_origin as Vector2i) and is_processing_input():
			if Input.is_action_pressed("ui_left"):
				new_pos.x -= 16
			elif Input.is_action_pressed("ui_right") and not Input.is_action_pressed("ui_left"):
				new_pos.x += 16
			if Input.is_action_pressed("ui_up"):
				new_pos.y -= 16
			elif Input.is_action_pressed("ui_down") and not Input.is_action_pressed("ui_up"):
				new_pos.y += 16
		move(new_pos)
	if (transform.get_origin()) != Vector2(_rel_pos + GenVars.get_map_camera().map_offset):
		_true_origin = _true_origin.move_toward(get_rel_pos(),
				max(1, _true_origin.distance_to(get_rel_pos())/16) * 4)
		transform.origin = _true_origin + Vector2(GenVars.get_map_camera().map_offset)


func set_true_pos(new_pos: Vector2i) -> void:
	# Sets cursor position relative to the map
	set_rel_pos(new_pos - Vector2i(GenVars.get_map_camera().true_origin))


func get_true_pos() -> Vector2i:
	return get_rel_pos() + Vector2i(GenVars.get_map_camera().true_origin)


func enable() -> void:
	_set_active(true)


func disable() -> void:
	_set_active(false)


func draw_icon(icon: icons) -> void:
	if not _icon_sprite:
		_icon_sprite = Sprite2D.new()
		_icon_sprite.centered = false
		add_child(_icon_sprite)
	match icon:
		icons.ATTACK:
			_icon_sprite.texture = preload("res://Cursor/attack.png")
			_icon_sprite.position = Vector2i(0, -16)


func remove_icon() -> void:
	if is_instance_valid(_icon_sprite):
		_icon_sprite.queue_free()


func connect_to(caller: Object):
	if caller.has_method("_on_cursor_select"):
		select.connect(caller._on_cursor_select)
	if caller.has_method("_on_cursor_cancel"):
		cancel.connect(caller._on_cursor_cancel)
	if caller.has_method("_on_cursor_moved"):
		moved.connect(caller._on_cursor_moved)


func disconnect_from(caller: Object):
	if caller.has_method("_on_cursor_select"):
		select.disconnect(caller._on_cursor_select)
	if caller.has_method("_on_cursor_cancel"):
		cancel.disconnect(caller._on_cursor_cancel)
	if caller.has_method("_on_cursor_moved"):
		moved.disconnect(caller._on_cursor_moved)


func set_rel_pos(new_pos: Vector2i) -> void:
	var top_bounds: Vector2i = Vector2i(4, 4)
	var bottom_bounds: Vector2i = GenVars.get_screen_size() - Vector2i(4, 4)
	new_pos = GenFunc.round_coords_to_tile(new_pos)
	var map_move := Vector2i()
	for i in 2:
		if (GenVars.get_map() as Map).get_rel_upper_border()[i] >= 0:
			top_bounds[i] = GenVars.get_map().get_rel_upper_border()[i]
		if (GenVars.get_map() as Map).get_rel_lower_border()[i] >= 0:
			bottom_bounds[i] = GenVars.get_screen_size()[i] - GenVars.get_map().get_rel_lower_border()[i]

		while new_pos[i] <= -16:
			new_pos[i] += 16
		while new_pos[i] + 16 >= GenVars.get_screen_size()[i] + 16:
			new_pos[i] -= 16

		while top_bounds[i] > new_pos[i]:
			map_move[i] -= 16
			new_pos[i] += 16
		while bottom_bounds[i] < new_pos[i] + 16:
			map_move[i] += 16
			new_pos[i] -= 16

	if map_move != Vector2i():
		GenVars.get_map_camera().move(map_move)
	if _rel_pos != new_pos:
		_rel_pos = new_pos
		emit_signal("moved")


func get_rel_pos() -> Vector2i:
	return _rel_pos


func get_area() -> Area2D:
	# Returns the cursor area.
	if GenVars.get_map():
		return GenVars.get_map().get_node("Cursor Area")
	else:
		push_error("Could not find Cursor Area")
		return null


func move(new_pos: Vector2i) -> void:
	set_rel_pos(new_pos + get_rel_pos())


func can_move(new_pos: Vector2i) -> bool:
	var old_pos: Vector2i = get_rel_pos()
	move(new_pos)
	var answer: bool
	if get_rel_pos() == old_pos:
		answer = false
	else:
		answer = true
	set_rel_pos(old_pos)
	return answer


func get_hovered_unit() -> Unit:
	for unit in get_tree().get_nodes_in_group("units"):
		if Vector2i((unit as Unit).position) == get_true_pos():
			return unit
	return null


func _set_active(active: bool) -> void:
	set_process_input(active)
	get_area().monitorable = active
	get_area().monitoring = active