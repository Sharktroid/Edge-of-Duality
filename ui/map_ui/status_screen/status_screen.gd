extends Control

var observing_unit: Unit

var _scroll_lock: bool = false

static var previous_tab: int = 0


func _ready() -> void:
	grab_focus()
	$"Menu Screen/Menu Tabs".current_tab = previous_tab
	var internal_tab_bar: TabBar = ($"Menu Screen/Menu Tabs".get_child(0, true))
	internal_tab_bar.mouse_filter = Control.MOUSE_FILTER_PASS

	_update.call_deferred()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()
	elif event.is_action_pressed("left"):
		GenFunc.switch_tab($"Menu Screen/Menu Tabs", -1)
	elif event.is_action_pressed("right"):
		GenFunc.switch_tab($"Menu Screen/Menu Tabs", 1)
	elif not _scroll_lock:
		if Input.is_action_pressed("up"):
			observing_unit = MapController.map.get_previous_unit(observing_unit)
			_move(1)
		elif Input.is_action_pressed("down"):
			observing_unit = MapController.map.get_next_unit(observing_unit)
			_move(-1)


func _has_point(_point: Vector2) -> bool:
	return true


func close() -> void:
	MapController.map.grab_focus()
	queue_free()
	previous_tab = $"Menu Screen/Menu Tabs".current_tab


func _update() -> void:
	%Portrait.texture = observing_unit.get_portrait()
	%Portrait.position = observing_unit.get_portrait_offset()

	%"Unit Name".text = observing_unit.name
	%"Class Name".text = observing_unit.unit_class.name

	_set_label_text_to_number(%"Current Level", observing_unit.current_level)
	_set_label_text_to_number(%"Max Level", observing_unit.get_max_level())

	_set_label_text_to_number(%"Current HP", roundi(observing_unit.get_current_health()))
	_set_label_text_to_number(%"Max HP", observing_unit.get_stat(Unit.stats.HITPOINTS))

	if observing_unit.get_current_weapon():
		_set_label_text_to_number(%"Attack Value", observing_unit.get_attack())
	else:
		%"Attack Value".text = "--"
	_set_label_text_to_number(%"AS Value", observing_unit.get_attack_speed())

	var current_weapon: Weapon = observing_unit.get_current_weapon()
	if current_weapon:
		_set_label_text_to_number(%"Min Range", current_weapon.min_range)
		if current_weapon.min_range == current_weapon.max_range:
			%"Range Separator".visible = false
			%"Max Range".text = ""
		else:
			%"Range Separator".visible = true
			_set_label_text_to_number(%"Max Range", current_weapon.max_range)
	else:
		%"Min Range".text = "--"
		%"Range Separator".visible = false
		%"Max Range".text = ""

	$"Menu Screen/Menu Tabs/Statistics".observing_unit = observing_unit
	$"Menu Screen/Menu Tabs/Items".observing_unit = observing_unit

	$"Menu Screen/Menu Tabs/Statistics".update()
	$"Menu Screen/Menu Tabs/Items".update()


func _set_label_text_to_number(label: Label, num: int) -> void:
	label.text = str(num)


func _move(dir: int) -> void:
	_scroll_lock = true
	const DURATION = 1.0/6
	var dest: float = $"Menu Screen".size.y
	var fade_threshold: float = 1.0/4
	var swap_threshold: float = 1.0/3
	var get_x: Callable = func(): return $"Menu Screen".position.y * dir
	var velocity: Callable = func():
		var dist: float = $"Menu Screen".size.y * swap_threshold
		return dist * 2 * GenVars.get_frame_delta() * dir / DURATION

	while get_x.call() <= dest * swap_threshold:
		await get_tree().process_frame
		$"Menu Screen".position.y += velocity.call()
		var weight: float = inverse_lerp(0, dest * fade_threshold, get_x.call())
		$"Menu Screen".modulate.a = lerpf(1, 0, weight)

	$"Menu Screen".position.y = -dest * dir * swap_threshold
	_update()

	while get_x.call() < 0:
		await get_tree().process_frame
		$"Menu Screen".position.y += velocity.call()
		var weight: float = inverse_lerp(-dest * fade_threshold, 0, get_x.call())
		$"Menu Screen".modulate.a = lerpf(0, 1, weight)

	$"Menu Screen".position.y = 0
	_scroll_lock = false


func _on_menu_tabs_tab_changed(_tab: int) -> void:
	HelpPopupController.shrink()