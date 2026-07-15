extends Node

const THAI_FONT: FontFile = preload("res://assets/fonts/NotoSansThai-Regular.ttf")
const MYANMAR_FONT: FontFile = preload("res://assets/fonts/NotoSansMyanmar-Regular.ttf")

var refresh_timer: float = 0.0


func _ready() -> void:
	_setup_fallbacks()
	get_tree().node_added.connect(_on_node_added)
	call_deferred("_apply_current_scene")


# Cross-link the two fonts so a single font covers Thai + Myanmar + Latin.
# This means the project-wide default font (Noto Sans Thai) can also render
# Myanmar text via fallback, so nothing ever shows as tofu boxes.
func _setup_fallbacks() -> void:
	# Copy the const references into local vars first: Godot 4.7 forbids
	# assigning to a member of a const, but the shared resource itself is
	# still mutable through a normal reference.
	var thai_font: Font = THAI_FONT
	var myanmar_font: Font = MYANMAR_FONT
	var thai_fallbacks: Array[Font] = [myanmar_font]
	var myanmar_fallbacks: Array[Font] = [thai_font]
	thai_font.fallbacks = thai_fallbacks
	myanmar_font.fallbacks = myanmar_fallbacks


func _process(delta: float) -> void:
	refresh_timer += delta

	if refresh_timer >= 0.4:
		refresh_timer = 0.0
		_apply_current_scene()


func _on_node_added(node: Node) -> void:
	if node is Control:
		call_deferred("_apply_to_tree", node)


func _apply_current_scene() -> void:
	if get_tree().current_scene != null:
		_apply_to_tree(get_tree().current_scene)


func _apply_to_tree(node: Node) -> void:
	if node is Control:
		_apply_font_to_control(node)

	for child in node.get_children():
		_apply_to_tree(child)


func _apply_font_to_control(control: Control) -> void:
	var text_value := _get_control_text(control)

	if _contains_myanmar(text_value):
		control.add_theme_font_override("font", MYANMAR_FONT)
	else:
		control.add_theme_font_override("font", THAI_FONT)


func _get_control_text(control: Control) -> String:
	if control is Label:
		return control.text

	if control is Button:
		return control.text

	if control is RichTextLabel:
		return control.text

	return ""


func _contains_thai(text_value: String) -> bool:
	for index in range(text_value.length()):
		var code := text_value.unicode_at(index)

		if code >= 0x0E00 and code <= 0x0E7F:
			return true

	return false


func _contains_myanmar(text_value: String) -> bool:
	for index in range(text_value.length()):
		var code := text_value.unicode_at(index)

		if code >= 0x1000 and code <= 0x109F:
			return true

		if code >= 0xAA60 and code <= 0xAA7F:
			return true

		if code >= 0xA9E0 and code <= 0xA9FF:
			return true

	return false
