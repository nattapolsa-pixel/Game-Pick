extends Control


func _ready() -> void:
	_build_ui()


func _build_ui() -> void:
	_add_background()

	var page := MarginContainer.new()
	page.set_anchors_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("margin_left", 56)
	page.add_theme_constant_override("margin_top", 44)
	page.add_theme_constant_override("margin_right", 56)
	page.add_theme_constant_override("margin_bottom", 44)
	add_child(page)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	page.add_child(scroll)

	var root := VBoxContainer.new()
	root.alignment = BoxContainer.ALIGNMENT_CENTER
	root.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root.add_theme_constant_override("separation", 18)
	scroll.add_child(root)

	var guide_card := PanelContainer.new()
	guide_card.custom_minimum_size = Vector2(620, 540)
	guide_card.add_theme_stylebox_override("panel", _panel_style(Color(0.085, 0.115, 0.120, 0.98), Color(0.90, 0.64, 0.22), 14, 2))
	root.add_child(guide_card)

	var guide_box := VBoxContainer.new()
	guide_box.add_theme_constant_override("separation", 14)
	guide_card.add_child(guide_box)

	var title := _make_label(_t("คู่มือก่อนเล่น", "How to Play"), 36, Color(0.95, 0.99, 0.96), true)
	guide_box.add_child(title)

	var intro := _make_label(_t("จำไว้สั้นๆ: ถูก Location, ถูก SKU, ถูกจำนวน, ถูก Action", "Remember: correct Location, SKU, Qty, and Action"), 18, Color(0.78, 0.90, 0.86), false)
	intro.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	guide_box.add_child(intro)

	var steps := [
		_t("1. ดู Pick List ทางขวา", "1. Check the Pick List"),
		_t("2. เดินไปหา rack สีทอง", "2. Walk to the gold rack"),
		_t("3. กด E หรือ Space เพื่อเช็ค Location", "3. Press E or Space to check"),
		_t("4. เลือก Confirm / Short Pick ให้ตรงสถานการณ์", "4. Choose the correct action")
	]

	for step in steps:
		var row := _make_step_row(step)
		guide_box.add_child(row)

	var control_note := _make_label(_t("ปุ่มเดิน: WASD หรือ ลูกศร | เช็คจุด: E / Space / Enter", "Move: WASD or Arrows | Check: E / Space / Enter"), 16, Color(1.0, 0.79, 0.36), false)
	control_note.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	guide_box.add_child(control_note)

	var button_row := HBoxContainer.new()
	button_row.alignment = BoxContainer.ALIGNMENT_CENTER
	button_row.add_theme_constant_override("separation", 10)
	guide_box.add_child(button_row)

	var test_button := _make_button(_t("ทำ Pre-Test", "Take Pre-Test"))
	test_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/PreTestScene.tscn"))
	button_row.add_child(test_button)

	var mission_button := _make_button(_t("เลือกภารกิจ", "Choose Mission"))
	mission_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MissionSelect.tscn"))
	button_row.add_child(mission_button)

	var back_button := _make_button(_t("กลับหน้าหลัก", "Main Menu"))
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	guide_box.add_child(back_button)

	var visual_card := PanelContainer.new()
	visual_card.custom_minimum_size = Vector2(520, 430)
	visual_card.add_theme_stylebox_override("panel", _panel_style(Color(0.100, 0.155, 0.145, 0.96), Color(0.28, 0.44, 0.38), 14, 2))
	root.add_child(visual_card)

	var visual := Control.new()
	visual_card.add_child(visual)
	_build_visual_guide(visual)


func _build_visual_guide(parent: Control) -> void:
	_add_child_rect(parent, Vector2(28, 38), Vector2(460, 310), Color(0.12, 0.19, 0.18), "MiniFloor")
	_add_child_rect(parent, Vector2(42, 250), Vector2(420, 24), Color(0.07, 0.21, 0.19), "MiniLane")
	for index in range(3):
		var x := 78 + index * 132
		_add_child_rect(parent, Vector2(x, 86), Vector2(86, 52), Color(0.18, 0.36, 0.32), "MiniRack")
		_add_child_rect(parent, Vector2(x, 160), Vector2(86, 52), Color(0.18, 0.36, 0.32), "MiniRack")
	_add_child_rect(parent, Vector2(342, 86), Vector2(86, 52), Color(0.96, 0.66, 0.18), "GoldTarget")
	_add_child_rect(parent, Vector2(58, 262), Vector2(34, 34), Color(0.95, 0.70, 0.26), "Picker")
	_add_child_label(parent, _t("สีทอง = จุดที่ต้องไป", "Gold = target"), Vector2(304, 50), Vector2(180, 28), 16, Color(1.0, 0.83, 0.38))
	_add_child_label(parent, _t("ตัวละคร", "Player"), Vector2(28, 302), Vector2(100, 28), 15, Color(0.95, 0.99, 0.96))
	_add_child_label(parent, _t("ไปที่ rack สีทอง แล้วกด E", "Go to the gold rack and press E"), Vector2(82, 360), Vector2(360, 34), 18, Color(0.95, 0.99, 0.96))


func _make_step_row(text: String) -> PanelContainer:
	var panel := PanelContainer.new()
	panel.add_theme_stylebox_override("panel", _panel_style(Color(0.115, 0.170, 0.160), Color(0.22, 0.34, 0.31), 8, 1))
	var label := _make_label(text, 18, Color(0.94, 0.99, 0.96), false)
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	panel.add_child(label)
	return panel


func _add_background() -> void:
	var bg := preload("res://scripts/vibrant_background.gd").new()
	add_child(bg)


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


func _add_child_label(parent: Control, text: String, pos: Vector2, rect_size: Vector2, font_size: int, color: Color) -> void:
	var label := _make_label(text, font_size, color, true)
	label.position = pos
	label.size = rect_size
	parent.add_child(label)


func _make_label(text: String, font_size: int, color: Color, bold: bool) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	if bold:
		label.add_theme_color_override("font_shadow_color", Color(0, 0, 0, 0.45))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 1)
	return label


func _make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.focus_mode = Control.FOCUS_NONE
	button.custom_minimum_size = Vector2(190, 44)
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color(0.95, 0.99, 0.96))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.86, 0.45))
	button.add_theme_stylebox_override("normal", _button_style(Color(0.15, 0.25, 0.23), Color(0.33, 0.48, 0.42)))
	button.add_theme_stylebox_override("hover", _button_style(Color(0.19, 0.31, 0.28), Color(0.44, 0.62, 0.54)))
	button.add_theme_stylebox_override("pressed", _button_style(Color(0.11, 0.20, 0.18), Color(0.33, 0.48, 0.42)))
	return button


func _panel_style(bg_color: Color, border_color: Color, radius: int, border_width: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(border_width)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 24
	style.content_margin_right = 24
	style.content_margin_top = 22
	style.content_margin_bottom = 22
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


func _t(th_text: String, mm_text: String) -> String:
	if GameState.current_language == "TH":
		return th_text
	return mm_text
