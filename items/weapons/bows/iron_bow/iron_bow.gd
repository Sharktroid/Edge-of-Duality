class_name Iron_Bow
extends Bow


# Weapon-specific variables.
func _init():
	name = "Iron Bow"
	level = ranks.E
	might = 7
	weight = 6
	hit = 65
	crit = 0
	max_uses = 40
	price = 2200
	weapon_experience = 1
#	effective_classes
	icon = load("uid://cdjtbe143l44v")
	super()