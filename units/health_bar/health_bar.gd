extends ProgressBar

var parent_unit: Unit


func _ready() -> void:
	add_theme_stylebox_override("fill", get_theme_stylebox("fill").duplicate())
	parent_unit = get_parent()
	update()


func update() -> void:
	max_value = parent_unit.get_stat(Unit.stats.HITPOINTS)
	value = parent_unit.get_current_health()
	if ratio == 1:
		visible = false
	else:
		visible = true
		(get_theme_stylebox("fill") as StyleBoxFlat).bg_color = _get_color()


func _get_color() -> Color:
	# Colors used
	var full_color = Color(0, 0.75, 0) # color at full health
	var half_color = Color(0.9, 0.9, 0) # color at half health
	var zero_color = Color(0.75, 0, 0) # color at no health
	var final_color = Color()
	# Deriving color from linear regresson
	if ratio > 0.5:
		final_color = half_color.lerp(full_color, inverse_lerp(.5, 1, ratio))
	else:
		final_color = zero_color.lerp(half_color, inverse_lerp(0, 0.5, ratio))
	return final_color