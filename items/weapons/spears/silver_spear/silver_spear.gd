class_name SilverLance
extends Spear


# Weapon-specific variables.
func _init() -> void:
	resource_name = "Silver Spear"
	_rank = Ranks.A
	_hit = 100
	_might = 20
	_crit = 0
	_weight = 10
	_max_uses = 20
	_price = 4000
	_weapon_exp = 1
	_description = "A very powerful and expensive spear."
	super()
