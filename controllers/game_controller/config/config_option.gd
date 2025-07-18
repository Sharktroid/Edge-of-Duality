## A class that automatically stores a value in config.cfg.
class_name ConfigOption
extends RefCounted

signal value_updated

var _name: StringName
var _category: StringName
var _value: StringName:
	set(value):
		_value = value
		_file.set_value(_category, _name, _value)
		_file.save("user://config.cfg")
		value_updated.emit()
var _default: StringName
var _description: String
static var _file: ConfigFile


func _init() -> void:
	if not _file:
		_file = ConfigFile.new()
		_file.load("user://config.cfg")
	_value = _file.get_value(_category, _name, _default)


## Gets the category. This is used in the config file as the section.
func get_category() -> StringName:
	return _category


## Gets the name. This is used in the config file as the key.
func get_name() -> StringName:
	return _name


## Gets the description of the ConfigOption. Takes the value as a parameter.
func get_description(_option: StringName) -> String:
	return _description
