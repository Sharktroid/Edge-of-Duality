# Object for handling factions
class_name Faction
extends RefCounted

signal name_changed(old_name: String)

## Valid inputs for the "player_type" field.
enum PlayerTypes { HUMAN, COMPUTER, NONE }
## Valid inputs for the "color" field.
enum Colors { BLUE, RED, GREEN, PURPLE }
## The possible diplomacy stances with other factions.
enum DiplomacyStances { ALLY, PEACE, ENEMY, SELF }

## Whether the full outline is shown.
var full_outline: bool = false
## Faction's name.
var name: String:
	set(value):
		var old_name: String = name
		name = value
		name_changed.emit(old_name)
## Color of all units.
var color: Colors
var player_type: PlayerTypes
## The units that are outlined.
var outlined_units: Dictionary[Faction, Array]
## The faction's theme.
var theme: AudioStream
## Whether the units have their x flipped.
var flipped: bool

var _diplomacy: Dictionary[Faction, DiplomacyStances]


func _init(
	faction_name: String,
	faction_color: Colors,
	faction_player_type: PlayerTypes,
	faction_theme: AudioStream,
	flip: bool = false
) -> void:
	name = faction_name
	color = faction_color
	player_type = faction_player_type
	theme = faction_theme
	flipped = flip


func _to_string() -> String:
	return 'Faction:"{name}"<#{id}>'.format({"name": name, "id": get_instance_id()})


func get_group_name() -> StringName:
	return &"%s_unit" % name.to_snake_case()


func get_diplomacy_stance(faction: Faction) -> DiplomacyStances:
	if faction == self:
		return DiplomacyStances.SELF
	else:
		return _diplomacy.get(faction, DiplomacyStances.ENEMY)


func set_diplomacy_stance(faction: Faction, new_stance: DiplomacyStances) -> void:
	_diplomacy[faction] = new_stance


## Returns true if the other faction is friendly (is self or ally).
func is_friend(other_faction: Faction) -> bool:
	return get_diplomacy_stance(other_faction) in [DiplomacyStances.SELF, DiplomacyStances.ALLY]


## Gets the units that belong to the faction.
func get_units() -> Array[Unit]:
	var units: Array[Unit] = []
	# Use groups as it is faster than using get_units and checking each unit.
	# Checking for tree to prevent an annoying crash when shutting down.
	if MapController.get_tree():
		units.assign(MapController.get_tree().get_nodes_in_group(get_group_name()))
	return units


## Returns true if the faction is friendly to a human.
func is_friendly_to_human() -> bool:
	var is_human_friend: Callable = func(human_faction: Faction) -> bool:
		return human_faction.player_type == Faction.PlayerTypes.HUMAN and is_friend(human_faction)
	return MapController.map.all_factions.any(is_human_friend)


func get_authority() -> int:
	var units: Array[Unit] = get_units().filter(
		func(unit: Unit) -> bool: return unit.get_authority() > 0
	)
	return units.reduce(
		func(accumulator: int, unit: Unit) -> int: return accumulator + unit.get_authority(), 0
	)
