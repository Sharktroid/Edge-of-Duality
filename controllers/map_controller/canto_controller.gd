class_name CantoController
extends SelectedUnitController

var _movement_tiles: Node2D


func _init(unit: Unit) -> void:
	_movement_tiles = MapController.map.display_tiles(
		unit.get_movement_tiles(), Map.TileTypes.MOVEMENT, 1.0
	)
	unit.selected = true
	unit.set_animation(Unit.Animations.MOVING_DOWN)
	super(unit)


func close() -> void:
	remove_tiles()
	_unit.selected = false
	super()


func remove_tiles() -> void:
	if is_instance_valid(_movement_tiles):
		_movement_tiles.queue_free()


func _position_selected() -> void:
	if CursorController.map_position in _unit.get_actionable_movement_tiles():
		AudioPlayer.play_sound_effect(AudioPlayer.MENU_SELECT)
		const MenuScript = preload("res://ui/map_ui/map_menus/canto_menu/canto_menu.gd")
		var menu_node := load("res://ui/map_ui/map_menus/canto_menu/canto_menu.tscn") as PackedScene
		var menu := menu_node.instantiate() as MenuScript
		menu.connected_unit = _unit
		menu.offset = CursorController.screen_position + Vector2i(16, -8)
		menu.caller = self
		CursorController.disable()
		MapController.get_ui().add_child(menu)


func _canceled() -> void:
	pass
