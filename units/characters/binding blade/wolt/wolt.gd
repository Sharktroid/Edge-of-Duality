@tool
extends Unit


# Unit-specific variables.
func _enter_tree() -> void:
	_personal_hit_points = 5
	_personal_strength = 5
	_personal_pierce = 7
	_personal_intelligence = 5
	_personal_dexterity = 10
	_personal_speed = 13
	_personal_luck = 9
	_personal_defense = 7
	_personal_armor = 5
	_personal_resistance = 5
	_personal_movement = 0
	_personal_build = 5
	super()
