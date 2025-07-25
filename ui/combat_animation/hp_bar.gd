extends VBoxContainer

const HPCell = preload("res://ui/combat_animation/hp_cell/hp_cell.gd")
const _MAX_CELLS: int = 80

@export var max_hp: int = 1:
	set(value):
		max_hp = value
		hp = clampi(hp, 0, max_hp)
@export var hp: int = 1:
	set(value):
		var old_hp: int = hp
		hp = clampi(value, 0, max_hp)
		if is_node_ready():
			_toggle_range(old_hp, hp)


func _ready() -> void:
	for index in max_hp:
		var child: HPCell = preload("res://ui/combat_animation/hp_cell/hp_cell.tscn").instantiate()
		if index < _MAX_CELLS/2:
			$BottomRow.add_child(child)
		else:
			$TopRow.add_child(child)
	#_toggle_range(0, hp)


func _toggle_range(old_hp: int, new_hp: int) -> void:
	var adding: bool = new_hp > old_hp
	var range: Array[int] = range(old_hp, new_hp) if adding else range(new_hp, old_hp)
	for index in range:
		var parent: Node = $BottomRow if index < _MAX_CELLS/2 else $TopRow
		var cell := ($BottomRow.get_child(index) if index < _MAX_CELLS/2 else $BottomRow.get_child(index-_MAX_CELLS/2)) as HPCell
		cell.fast_layer = adding
		var tween: Tween = create_tween()
		tween.set_speed_scale(max_hp)
		var timer: int = index - old_hp if adding else old_hp - index
		tween.tween_callback(func() -> void: cell.slow_layer = adding).set_delay(timer)


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("left"):
		hp = 0
	elif event.is_action_pressed("right"):
		hp = max_hp
	elif event.is_action_pressed("back"):
		for child: HPCell in get_children():
			child.shatter()
