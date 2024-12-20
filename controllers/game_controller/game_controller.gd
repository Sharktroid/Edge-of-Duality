## Autoload that manages global functions and variables.
extends Node

## The possible types of controller that can be used.
enum ControllerTypes { MOUSE, KEYBOARD }

const _RECEIVER = preload("res://controllers/game_controller/receive_input_node.gd")
## Type of controller currently being used.
var controller_type: ControllerTypes

var _input_stack: Array[Node] = []


func _init() -> void:
	seed(0)  # Sets RNG to be deterministic
	controller_type = ControllerTypes.MOUSE


func _ready() -> void:
	_update_fps_display()
	DebugConfig.SHOW_FPS.value_updated.connect(_update_fps_display)


func _physics_process(_delta: float) -> void:
	randi()  # Burns a random number every frame


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton or event is InputEventMouseMotion:
		controller_type = ControllerTypes.MOUSE
	else:
		controller_type = (ControllerTypes.KEYBOARD)

	if DebugConfig.PRINT_INPUT_RECEIVER.value:
		print("Input node: %s" % get_current_input_node())
	# Ignore pseudo-virtual method
	# gdlint:ignore = private-method-call
	get_current_input_node()._receive_input(event)

	if event.is_action_pressed("fullscreen"):
		match get_window().mode:
			Window.MODE_EXCLUSIVE_FULLSCREEN, Window.MODE_FULLSCREEN:
				get_window().mode = Window.MODE_WINDOWED
			Window.MODE_MAXIMIZED, Window.MODE_MINIMIZED, Window.MODE_WINDOWED:
				get_window().mode = Window.MODE_EXCLUSIVE_FULLSCREEN


## Adds a [Node] to the input stack, and makes that node the input receiver.
func add_to_input_stack(node: Node) -> void:
	_input_stack.append(node)


## Removes the current input receiving [Node] from the input stack
## and sets the last input receiving [Node] as the current one.
func remove_from_input_stack() -> void:
	_input_stack.remove_at(_input_stack.size() - 1)


## Gets the current input receiving [Node].
func get_current_input_node() -> _RECEIVER:
	if _input_stack.size() == 0:
		return _RECEIVER.new()
	while not is_instance_valid(_input_stack[-1]):
		remove_from_input_stack()
		if _input_stack.size() == 0:
			return _RECEIVER.new()
	return _input_stack[-1]


## Gets the [SubViewport] that all nodes originate in.
func get_root() -> Viewport:
	const PATH: String = "SubViewportContainer/SubViewport"
	if get_viewport() and get_viewport().has_node(PATH):
		return get_viewport().get_node(PATH) as Viewport
	return Window.new()


# Toggles the FPS display depending on the config
func _update_fps_display() -> void:
	(GameController.get_root().get_node("%FPSDisplay") as HBoxContainer).visible = (
		DebugConfig.SHOW_FPS.value
	)
