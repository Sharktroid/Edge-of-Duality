@tool
class_name Brigand
extends UnitClass


# Unit-specific variables.
func _init():
	name = "Brigand"
	max_level = 30
	movement_type = movement_types.BANDITS
	base_stats = {
		Unit.stats.HITPOINTS: 18,
		Unit.stats.STRENGTH: 6,
		Unit.stats.PIERCE: 0,
		Unit.stats.MAGIC: 1,
		Unit.stats.SKILL: 2,
		Unit.stats.SPEED: 5,
		Unit.stats.LUCK: 0,
		Unit.stats.DEFENSE: 7,
		Unit.stats.DURABILITY: 2,
		Unit.stats.RESISTANCE: 1,
		Unit.stats.MOVEMENT: 5,
		Unit.stats.CONSTITUTION: 0,
		Unit.stats.LEADERSHIP: 0,
	}
	end_stats = {
		Unit.stats.HITPOINTS: 34,
		Unit.stats.STRENGTH: 18,
		Unit.stats.PIERCE: 0,
		Unit.stats.MAGIC: 1,
		Unit.stats.SKILL: 9,
		Unit.stats.SPEED: 12,
		Unit.stats.LUCK: 3,
		Unit.stats.DEFENSE: 16,
		Unit.stats.DURABILITY: 9,
		Unit.stats.RESISTANCE: 7,
		Unit.stats.MOVEMENT: 5,
		Unit.stats.CONSTITUTION: 0,
		Unit.stats.LEADERSHIP: 0,
	}
	stat_caps = {
		Unit.stats.HITPOINTS: 45,
		Unit.stats.STRENGTH: 24,
		Unit.stats.PIERCE: 0,
		Unit.stats.MAGIC: 19,
		Unit.stats.SKILL: 16,
		Unit.stats.SPEED: 20,
		Unit.stats.LUCK: 17,
		Unit.stats.DEFENSE: 23,
		Unit.stats.DURABILITY: 20,
		Unit.stats.RESISTANCE: 18,
		Unit.stats.MOVEMENT: 7,
		Unit.stats.CONSTITUTION: 0,
		Unit.stats.LEADERSHIP: 0,
	}
	map_sprite = load("uid://k4v4jr2yobm1")