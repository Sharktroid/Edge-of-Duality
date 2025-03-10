@tool
extends Unit


# Unit-specific variables.
func _enter_tree() -> void:
	set_weapon_level(Weapon.Types.AXE, Weapon.Ranks.B)
	_personal_hit_points = 14
	_personal_strength = 10
	_personal_pierce = 5
	_personal_intelligence = 5
	_personal_dexterity = 9
	_personal_speed = 7
	_personal_luck = 5
	_personal_defense = 7
	_personal_armor = 5
	_personal_resistance = 5
	_personal_movement = 0
	_personal_build = 5
	super()
