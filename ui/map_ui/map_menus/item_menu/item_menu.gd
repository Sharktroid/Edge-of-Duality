extends MapMenu

var connected_unit: Unit

var _items: Array[Item] = []
var _menu_item_node: GDScript = load("res://ui/map_ui/map_menus/item_menu/item_menu_item.gd")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_update()
	reset_size()
	super()


func _process(_delta: float) -> void:
	_update()


func select_item(item: MapMenuItem) -> void:
	var menu: MapMenu = load("uid://bfd30uyseuacp").instantiate()
	menu.offset = offset + Vector2(16, 20)
	menu.parent_menu = self
	menu.unit = connected_unit
	menu.item = item.item
	MapController.get_ui().add_child(menu)
	super(item)


func close() -> void:
	parent_menu.update()
	super()


func _update() -> void:
	if _items != connected_unit.items:
		_items = connected_unit.items.duplicate()
		if len(_items) <= 0:
			close()
		for child in $Items.get_children():
			child.queue_free()
			await child.tree_exited
		for item in connected_unit.items:
			var item_node: HelpContainer = _menu_item_node.new(item)
			item_node.help_description = item.get_description()
			$Items.add_child(item_node)