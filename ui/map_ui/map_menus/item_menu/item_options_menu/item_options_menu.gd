extends MapMenu
var item: Item
var unit: Unit


func _enter_tree() -> void:
	if not item is Weapon:
		($Items/Equip as MapMenuItem).visible = false
	if not item.is_usable():
		($Items/Use as MapMenuItem).visible = false
	if not item.is_droppable():
		($Items/Drop as MapMenuItem).visible = false
	reset_size.call_deferred()
	super()


func select_item(menu_item: MapMenuItem) -> void:
	match menu_item.name:
		"Equip":
			unit.equip_weapon(item as Weapon)
			close()
		"Use":
			item.use()
			close()
		"Drop":
			const MENU_PATH: String = (
				"res://ui/map_ui/map_menus/confirmation_map_menu/confirmation_map_menu."
			)
			const Menu = preload(MENU_PATH + "gd")
			var menu := (load(MENU_PATH + "tscn") as PackedScene).instantiate() as Menu
			menu.offset = offset + Vector2(16, 16)
			menu.parent_menu = self
			MapController.get_ui().add_child(menu)
			if await menu.selection_made:
				unit.drop(item)
				close()
			menu.queue_free()
	super(menu_item)
