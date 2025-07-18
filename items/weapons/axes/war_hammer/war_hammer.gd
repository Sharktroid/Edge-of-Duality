class_name WarHammer
extends Axe


func _init() -> void:
	super()
	resource_name = "War Hammer"
	_rank = Ranks.C
	_max_uses = 30
	_price = 37
	_might += 3
	_hit -= 5
	_flavor_text = "A heavy hammer designed to pierce armor."
	_description = "Effective against armored enemies. Halves enemy defense."