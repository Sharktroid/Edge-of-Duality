extends Control

const CHARS_PER_SECOND = 300
const FULL_SCROLL_SPEED = 0.25

enum positions {OUTSIDELEFT = -80, FARLEFT = 0, MIDLEFT = 80, CLOSELEFT = 160,
		CLOSERIGHT = 256, MIDRIGHT = 336, FARRIGHT = 416, OUTSIDERIGHT = 512}
enum directions {LEFT, RIGHT}

func _ready() -> void:
	#var top_text: String = "After defeating the dragons, the humans of Elibe quickly spread their culture and civilization to the farthest reaches of the continent.\nIn the west lies the Kingdom of Etruria, which is widely considered to possess the most refined culture in all of Elibe. The Kingdom of Bern, with its powerful military and logical, pragmatic people, is located on the other side of the continent in the east."
	#var bottom_text: String = "These are the two most powerful nations in Elibe with the weaker nations situated between them. These smaller lands are... the Lycian League, whose numerous territories are independently ruled by a number of marquesses that are bound by a vow of allegiance; Ilia, where the people arduously till the frozen soil and many become mercenaries to earn money to survive; and Sacae, where various clans ride through the plains on horseback."
	await get_tree().process_frame
	#var dialogue_queue: Array[Callable] = [set_top_text(top_text), set_top_text(bottom_text)]
	#for callable: Callable in dialogue_queue:
		#await callable.call()
	await set_top_text("1\n2\n3\n4\n5").call()
	await _scroll(%"Top Textbox" as RichTextLabel)
	await set_top_text("\n6").call()
	await clear_top().call()
	await set_top_text("a\nb\nc\nd\ne").call()


func set_top_text(string: String) -> Callable:
	return _set_text_base(string, %"Top Textbox" as RichTextLabel)


func set_bottom_text(string: String) -> Callable:
	return _set_text_base(string, %"Bottom Textbox" as RichTextLabel)


func clear_top() -> Callable:
	return _clear(%"Top Textbox" as RichTextLabel)


func _set_text_base(string: String, label: RichTextLabel) -> Callable:
	return func():
		label.text += string
		label.visible_ratio = 0
		label.visible_characters = label.text.length() - string.length()
		#region Gradually displays text
		while label.visible_ratio < 1:
			await get_tree().process_frame
			var next_visible_chars: int = (label.visible_characters +
					roundi(CHARS_PER_SECOND * GenVars.get_frame_delta()))
			while (label.visible_characters < next_visible_chars and label.visible_ratio < 1):
				label.visible_characters += 1
				# Delays for punctuation
				if label.text[label.visible_characters - 1] in [",", ".", ";", ":"]:
					await get_tree().create_timer(0.1).timeout
					break
		label.visible_ratio = 1
		#endregion
		while not Input.is_action_just_pressed("ui_accept"):
			await get_tree().process_frame


func _get_scroll_callable(label: RichTextLabel) -> Callable:
	return func() -> void:
		var new_y: int = roundi(label.position.y - 16)
		while label.position.y > new_y:
			label.position.y -= 80.0/60.0 / FULL_SCROLL_SPEED
			await get_tree().physics_frame


func _scroll(label: RichTextLabel) -> void:
	await _get_scroll_callable(label).call()


func _clear(label: RichTextLabel) -> Callable:
	return func() -> void:
		var starting_time: float = Engine.get_physics_frames()
		for i in 5:
			await _scroll(label)
		label.text = ""
		label.position.y = 0