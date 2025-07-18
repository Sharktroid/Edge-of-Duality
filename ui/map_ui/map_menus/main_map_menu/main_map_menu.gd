extends MapMenu


func _init() -> void:
	_to_center = true


func _enter_tree() -> void:
	($Items/Debug as MapMenuItem).visible = Options.DEBUG_ENABLED.value
	super()


func _exit_tree() -> void:
	super()


func _input(event: InputEvent) -> void:
	if not HelpPopupController.is_active():
		if event.is_action_pressed("back"):
			AudioPlayer.play_sound_effect(AudioPlayer.SoundEffects.DESELECT)
			queue_free()
			CursorController.enable()
		else:
			super(event)


static func instantiate(new_offset: Vector2, parent: MapMenu = null) -> MapMenu:
	return _base_instantiate(
		preload("res://ui/map_ui/map_menus/main_map_menu/main_map_menu.tscn"), new_offset, parent
	)


func _select_item(item: MapMenuItem) -> void:
	match item.name:
		"Debug":
			const DebugMenu = preload(
				"res://ui/map_ui/map_menus/debug_commands_menu/debug_commands_menu.gd"
			)
			MapController.get_ui().add_child(DebugMenu.instantiate(_offset, self))

		"Options":
			AudioPlayer.play_sound_effect(AudioPlayer.SoundEffects.MENU_SELECT)
			const OPTIONS_MENU: PackedScene = preload(
				"res://ui/map_ui/options_menu/options_menu.tscn"
			)
			MapController.get_ui().add_child(OPTIONS_MENU.instantiate())

		"End":
			MapController.map.end_turn.call_deferred()
			CursorController.enable()

		var node_name:
			push_error("%s is not a valid menu item" % node_name)
			CursorController.enable()
	queue_free()
	super(item)
