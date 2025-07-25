class_name Maul
extends Axe


func _init() -> void:
	super()
	resource_name = "Maul"
	_rank = Ranks.A
	_max_uses = 35
	_price = 46
	_might += 16
	_weight += 8
	_hit -= 10
	_flavor_text = "A heavy two-handed axe that can crush even the toughest armor."
	_description = "Effective against armored foes."