extends MapMenu


func get_items():
	return {
		Debug = null,
		Unit = null,
		Status = null,
		Guide = null,
		Options = null,
		Suspend = null,
		End = null,
	}


func select_item(item: String) -> void:
	match item:
		"Debug":
			var menu: MapMenu = load("uid://c0mmbk17nyqii").instantiate()
			menu.position = position
			menu.parent_menu = self
			MapController.get_node("UI Layer").add_child(menu)
			visible = false
		"End":
			close()
			MapController.map.end_turn()
		_: push_error("%s is not a valid menu item" % item)


func close() -> void:
	super()
	MapController.get_cursor().enable()