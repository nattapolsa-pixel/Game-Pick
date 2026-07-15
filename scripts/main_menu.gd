extends Control

const LOGO_PATH := "res://assets/DCWN.png"

var current_language: String = "TH"

var title_label: Label
var subtitle_label: Label
var thai_button: Button
var myanmar_button: Button
var start_button: Button
var guide_button: Button
var test_button: Button
var exit_button: Button
var preview_picker: ColorRect

const PLAYER_COLORS := [
	Color(0.95, 0.70, 0.26),
	Color(0.25, 0.82, 0.95),
	Color(0.98, 0.40, 0.66),
	Color(0.45, 0.90, 0.50),
	Color(0.65, 0.50, 0.98),
	Color(0.98, 0.45, 0.32)
]


func _ready() -> void:
	current_language = GameState.current_language
	_build_ui()
	_update_language()


func _build_ui() -> void:
	_add_background()
	_add_decorative_racks()

	var page := MarginContainer.new()
	page.set_anchors_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("margin_left", 48)
	page.add_theme_constant_override("margin_top", 40)
	page.add_theme_constant_override("margin_right", 48)
	page.add_theme_constant_override("margin_bottom", 40)
	add_child(page)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	page.add_child(scroll)

	var center := CenterContainer.new()
	center.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	center.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(center)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(680, 620)
	card.add_theme_stylebox_override("panel", _panel_style(Color(0.085, 0.115, 0.120, 0.97), Color(0.90, 0.64, 0.22), 14, 2))
	center.add_child(card)

	var box := VBoxContainer.new()
	box.alignment = BoxContainer.ALIGNMENT_CENTER
	box.add_theme_constant_override("separation", 8)
	card.add_child(box)

	var logo := _make_logo()
	if logo != null:
		box.add_child(logo)

	var badge := Label.new()
	badge.text = "DC PICK TRAINING"
	badge.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	badge.add_theme_font_size_override("font_size", 14)
	badge.add_theme_color_override("font_color", Color(1.0, 0.76, 0.30))
	box.add_child(badge)

	title_label = _make_label("", 42, Color(0.94, 0.99, 0.96), true)
	title_label.custom_minimum_size = Vector2(0, 50)
	box.add_child(title_label)

	subtitle_label = _make_label("", 18, Color(0.72, 0.84, 0.80), false)
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle_label.custom_minimum_size = Vector2(560, 44)
	box.add_child(subtitle_label)

	var preview := PanelContainer.new()
	preview.custom_minimum_size = Vector2(560, 92)
	preview.add_theme_stylebox_override("panel", _panel_style(Color(0.115, 0.170, 0.160), Color(0.21, 0.34, 0.30), 10, 1))
	box.add_child(preview)

	var preview_area := Control.new()
	preview.add_child(preview_area)
	_build_preview_map(preview_area)

	var language_row := HBoxContainer.new()
	language_row.alignment = BoxContainer.ALIGNMENT_CENTER
	language_row.add_theme_constant_override("separation", 10)
	box.add_child(language_row)

	thai_button = _make_button("")
	thai_button.custom_minimum_size = Vector2(150, 38)
	thai_button.pressed.connect(_on_thai_pressed)
	language_row.add_child(thai_button)

	myanmar_button = _make_button("")
	myanmar_button.custom_minimum_size = Vector2(170, 38)
	myanmar_button.pressed.connect(_on_myanmar_pressed)
	language_row.add_child(myanmar_button)

	_add_color_row(box)

	guide_button = _make_button("")
	guide_button.custom_minimum_size = Vector2(360, 42)
	guide_button.pressed.connect(_on_guide_pressed)
	box.add_child(guide_button)

	test_button = _make_button("")
	test_button.custom_minimum_size = Vector2(360, 42)
	test_button.pressed.connect(_on_test_pressed)
	box.add_child(test_button)

	start_button = _make_button("")
	start_button.custom_minimum_size = Vector2(360, 46)
	start_button.pressed.connect(_on_start_pressed)
	box.add_child(start_button)

	exit_button = _make_button("")
	exit_button.custom_minimum_size = Vector2(220, 38)
	exit_button.pressed.connect(_on_exit_pressed)
	box.add_child(exit_button)


func _build_preview_map(parent: Control) -> void:
	_add_child_rect(parent, Vector2(18, 14), Vector2(525, 7), Color(0.22, 0.34, 0.31), "PreviewLane")
	_add_child_rect(parent, Vector2(18, 68), Vector2(525, 16), Color(0.08, 0.23, 0.20), "PreviewBottom")
	for index in range(4):
		var x := 52 + index * 120
		_add_child_rect(parent, Vector2(x, 30), Vector2(72, 26), Color(0.19, 0.38, 0.33), "PreviewRack")
		_add_child_rect(parent, Vector2(x + 2, 34), Vector2(68, 3), Color(0.11, 0.25, 0.23), "PreviewSlot")
		_add_child_rect(parent, Vector2(x + 2, 43), Vector2(68, 3), Color(0.11, 0.25, 0.23), "PreviewSlot")
	preview_picker = _add_child_rect(parent, Vector2(34, 72), Vector2(48, 18), GameState.player_color, "PreviewPicker")


func _add_color_row(box: VBoxContainer) -> void:
	var row := HBoxContainer.new()
	row.alignment = BoxContainer.ALIGNMENT_CENTER
	row.add_theme_constant_override("separation", 8)
	box.add_child(row)

	var label := Label.new()
	label.text = _t("สีตัวละคร:", "Color:")
	label.add_theme_font_size_override("font_size", 15)
	label.add_theme_color_override("font_color", Color(0.80, 0.90, 0.86))
	row.add_child(label)

	for c in PLAYER_COLORS:
		row.add_child(_make_swatch(c))


func _make_swatch(color: Color) -> Button:
	var b := Button.new()
	b.custom_minimum_size = Vector2(34, 34)
	b.focus_mode = Control.FOCUS_NONE
	var normal := StyleBoxFlat.new()
	normal.bg_color = color
	normal.set_corner_radius_all(8)
	normal.set_border_width_all(2)
	normal.border_color = Color(1, 1, 1, 0.35)
	var hover: StyleBoxFlat = normal.duplicate()
	hover.border_color = Color(1, 1, 1, 0.95)
	b.add_theme_stylebox_override("normal", normal)
	b.add_theme_stylebox_override("hover", hover)
	b.add_theme_stylebox_override("pressed", hover)
	b.pressed.connect(_on_color_pressed.bind(color))
	return b


func _on_color_pressed(color: Color) -> void:
	GameState.player_color = color
	if preview_picker != null:
		preview_picker.color = color


func _t(th_text: String, mm_text: String) -> String:
	if current_language == "TH":
		return th_text
	return mm_text


func _add_background() -> void:
	var bg := preload("res://scripts/vibrant_background.gd").new()
	add_child(bg)


func _add_decorative_racks() -> void:
	for index in range(7):
		_add_rect(Vector2(56 + index * 86, 88), Vector2(50, 270), Color(0.16, 0.42, 0.46, 0.42), "RackLeft")
		_add_rect(Vector2(760 + index * 86, 390), Vector2(50, 230), Color(0.34, 0.20, 0.44, 0.40), "RackRight")


func _on_thai_pressed() -> void:
	current_language = "TH"
	GameState.current_language = "TH"
	_update_language()


func _on_myanmar_pressed() -> void:
	current_language = "MM"
	GameState.current_language = "MM"
	_update_language()


func _on_start_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/MissionSelect.tscn")


func _on_guide_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/TutorialScene.tscn")


func _on_test_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/PreTestScene.tscn")


func _on_exit_pressed() -> void:
	get_tree().quit()


func _update_language() -> void:
	if current_language == "TH":
		title_label.text = "Pick Training Simulator"
		subtitle_label.text = "เกมจำลองงาน Pick แบบสั้น เดินหา Location ตรวจสินค้า เลือก Action ให้ถูก แล้วเก็บคะแนน"
		thai_button.text = "TH ภาษาไทย"
		myanmar_button.text = "MM မြန်မာဘာသာ"
		guide_button.text = "คู่มือก่อนเล่น"
		test_button.text = "Pre-Test ก่อนเล่น"
		start_button.text = "เลือกภารกิจ"
		exit_button.text = "ออกจากเกม"
	else:
		title_label.text = "Pick Training Simulator"
		subtitle_label.text = "Pick လုပ်ငန်းအတွက် Location / SKU / Qty လေ့ကျင့်ရေးဂိမ်း"
		thai_button.text = "TH ภาษาไทย"
		myanmar_button.text = "MM မြန်မာဘာသာ"
		guide_button.text = "How to Play"
		test_button.text = "Pre-Test"
		start_button.text = "Mission ရွေးမည်"
		exit_button.text = "ထွက်မည်"

	_style_language_buttons()


func _style_language_buttons() -> void:
	if current_language == "TH":
		_apply_button_style(thai_button, Color(0.86, 0.54, 0.14), Color(1.0, 0.75, 0.30))
		_apply_button_style(myanmar_button, Color(0.13, 0.20, 0.20), Color(0.27, 0.39, 0.36))
	else:
		_apply_button_style(thai_button, Color(0.13, 0.20, 0.20), Color(0.27, 0.39, 0.36))
		_apply_button_style(myanmar_button, Color(0.86, 0.54, 0.14), Color(1.0, 0.75, 0.30))


func _add_rect(pos: Vector2, rect_size: Vector2, color: Color, node_name: String) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	add_child(rect)
	return rect


func _add_child_rect(parent: Control, pos: Vector2, rect_size: Vector2, color: Color, node_name: String) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	parent.add_child(rect)
	return rect


func _make_logo() -> TextureRect:
	var image := Image.new()
	if image.load(LOGO_PATH) != OK:
		return null

	var texture := ImageTexture.create_from_image(image)
	var logo := TextureRect.new()
	logo.texture = texture
	logo.ignore_texture_size = true
	logo.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	logo.custom_minimum_size = Vector2(112, 76)
	return logo


func _make_label(text: String, font_size: int, color: Color, bold: bool) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if bold:
		label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.45))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 1)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label


func _make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	_apply_button_style(button, Color(0.15, 0.25, 0.23), Color(0.33, 0.48, 0.42))
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color(0.95, 0.99, 0.96))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.86, 0.45))
	return button


func _apply_button_style(button: Button, bg_color: Color, border_color: Color) -> void:
	button.add_theme_stylebox_override("normal", _button_style(bg_color, border_color))
	button.add_theme_stylebox_override("hover", _button_style(bg_color.lightened(0.08), border_color.lightened(0.10)))
	button.add_theme_stylebox_override("pressed", _button_style(bg_color.darkened(0.08), border_color))


func _panel_style(bg_color: Color, border_color: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 26
	style.content_margin_right = 26
	style.content_margin_top = 24
	style.content_margin_bottom = 24
	return style


func _button_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 14
	style.content_margin_right = 14
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style
