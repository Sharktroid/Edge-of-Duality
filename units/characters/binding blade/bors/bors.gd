@tool
extends Unit


# Unit-specific variables.
func _enter_tree() -> void:
	_personal_hit_points = 12
	_personal_strength = 9
	_personal_pierce = 5
	_personal_intelligence = 5
	_personal_dexterity = 6
	_personal_speed = 8
	_personal_luck = 10
	_personal_defense = 8
	_personal_armor = 5
	_personal_resistance = 1
	_personal_movement = 0
	_personal_build = 5
	super()
