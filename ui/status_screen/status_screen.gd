extends Control

var observing_unit: Unit


func _enter_tree() -> void:
	$"Unit Information Menu/Menu Tabs/Statistics".observing_unit = observing_unit
	$"Unit Information Menu/Menu Tabs/Items".observing_unit = observing_unit

func _ready() -> void:
	grab_focus()
	var internal_tab_bar: TabBar = ($"Unit Information Menu/Menu Tabs".get_child(0, true))
	internal_tab_bar.mouse_filter = Control.MOUSE_FILTER_PASS
	_update()


func _gui_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"):
		close()


func _has_point(_point: Vector2) -> bool:
	return true


func close() -> void:
	queue_free()

func _update() -> void:
	_set_label_text_to_number(%"Current Level", observing_unit.current_level)
	_set_label_text_to_number(%"Max Level", observing_unit.get_max_level())

	_set_label_text_to_number(%"Current HP", roundi(observing_unit.get_current_health()))
	_set_label_text_to_number(%"Max HP", observing_unit.get_stat(Unit.stats.HITPOINTS))

	_set_label_text_to_number(%"Attack Value", observing_unit.get_attack())
	_set_label_text_to_number(%"AS Value", observing_unit.get_attack_speed())

	var current_weapon: Weapon = observing_unit.get_current_weapon()
	_set_label_text_to_number(%"Min Range", current_weapon.min_range)
	if current_weapon.min_range == current_weapon.max_range:
		%"Range Separator".visible = false
		%"Max Range".text = ""
	else:
		%"Range Separator".visible = true
		_set_label_text_to_number(%"Max Range", current_weapon.max_range)


func _set_label_text_to_number(label: Label, num: int) -> void:
	label.text = str(num)