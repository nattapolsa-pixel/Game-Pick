extends Control

var title_label: Label
var subtitle_label: Label
var mission_buttons: Array[Button] = []
var back_button: Button

var mission_defs := [
	{
		"title_th": "1. พื้นฐานการหยิบสินค้า",
		"title_mm": "1. အခြေခံ ပစ္စည်းယူခြင်း",
		"detail_th": "อ่าน Location, SKU, จำนวน แล้วกรอกให้ถูก (สินค้าเป็นหน่วยชิ้นทั้งหมด)",
		"detail_mm": "Location, SKU, Qty ကို မှန်အောင် ဖြည့်ပါ"
	},
	{
		"title_th": "2. เลือกหน่วยให้ถูก",
		"title_mm": "2. ယူနစ် မှန်အောင် ရွေးခြင်း",
		"detail_th": "แต่ละชิ้นหน่วยไม่เหมือนกัน (กล่อง/ลัง/แพ็ค/ถุง/ขวด) เลือกหน่วยให้ตรง Order",
		"detail_mm": "ပစ္စည်းတိုင်း ယူနစ်မတူပါ - မှန်အောင်ရွေးပါ"
	},
	{
		"title_th": "3. ของไม่พอ = แจ้ง Short Pick",
		"title_mm": "3. Qty မလုံလောက် = Short Pick",
		"detail_th": "ถ้าสต๊อกในชั้นไม่พอกับ Order ให้กด \"แจ้งของไม่พอ (Short Pick)\"",
		"detail_mm": "Stock မလုံလောက်ပါက Short Pick ကို နှိပ်ပါ"
	}
]


func _ready() -> void:
	_build_ui()
	_update_language()


func _build_ui() -> void:
	_add_background()
	_add_rect(Vector2(0, 0), Vector2(1600, 104), Color(0.05, 0.09, 0.13, 0.66), "HeaderBand")
	_add_rect(Vector2(0, 104), Vector2(1600, 4), Color(0.22, 0.86, 0.98), "HeaderAccent")

	var page := MarginContainer.new()
	page.set_anchors_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("margin_left", 22)
	page.add_theme_constant_override("margin_top", 22)
	page.add_theme_constant_override("margin_right", 22)
	page.add_theme_constant_override("margin_bottom", 22)
	add_child(page)

	var scroll := ScrollContainer.new()
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	page.add_child(scroll)

	var root_box := VBoxContainer.new()
	root_box.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_theme_constant_override("separation", 14)
	scroll.add_child(root_box)

	title_label = _make_label("", 30, Color(0.95, 0.99, 0.96), true)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_child(title_label)

	subtitle_label = _make_label("", 16, Color(0.74, 0.86, 0.82), false)
	subtitle_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	subtitle_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	subtitle_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	root_box.add_child(subtitle_label)

	var cards := VBoxContainer.new()
	cards.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	cards.add_theme_constant_override("separation", 12)
	root_box.add_child(cards)

	for index in range(mission_defs.size()):
		var button := _make_mission_button(index)
		button.pressed.connect(func(mission_index := index): _start_mission(mission_index + 1))
		mission_buttons.append(button)
		cards.add_child(button)

	back_button = _make_button("")
	back_button.custom_minimum_size = Vector2(0, 46)
	back_button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	back_button.pressed.connect(_on_back_pressed)
	root_box.add_child(back_button)


func _make_mission_button(index: int) -> Button:
	var button := Button.new()
	button.custom_minimum_size = Vector2(0, 128)
	button.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	button.focus_mode = Control.FOCUS_NONE
	button.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	button.add_theme_font_size_override("font_size", 18)
	button.add_theme_color_override("font_color", Color(0.97, 0.99, 0.96))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.84, 0.42))
	var colors := [
		[Color(0.15, 0.28, 0.25), Color(0.45, 0.74, 0.62)],
		[Color(0.20, 0.22, 0.31), Color(0.58, 0.66, 0.92)],
		[Color(0.29, 0.19, 0.16), Color(0.96, 0.62, 0.32)]
	]
	_apply_button_style(button, colors[index][0], colors[index][1], 12)
	return button


func _update_language() -> void:
	if GameState.current_language == "TH":
		title_label.text = "เลือกภารกิจ"
		subtitle_label.text = "เลือกด่านสั้นๆ แล้วทำคะแนนให้ดีที่สุด"
		back_button.text = "กลับหน้าแรก"
		for index in range(mission_buttons.size()):
			mission_buttons[index].text = "%s\n\n%s\n\nเวลาเล่น 1-3 นาที" % [mission_defs[index]["title_th"], mission_defs[index]["detail_th"]]
	else:
		title_label.text = "Mission ရွေးချယ်ပါ"
		subtitle_label.text = "တိုတောင်းသော mission ကိုရွေးပြီး score ရယူပါ"
		back_button.text = "မူလစာမျက်နှာသို့ ပြန်မည်"
		for index in range(mission_buttons.size()):
			mission_buttons[index].text = "%s\n\n%s\n\n1-3 minutes" % [mission_defs[index]["title_mm"], mission_defs[index]["detail_mm"]]


func _start_mission(mission_id: int) -> void:
	GameState.current_mission = mission_id
	GameState.score = 0
	get_tree().change_scene_to_file("res://scenes/GameScene.tscn")


func _on_back_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/main_menu.tscn")


func _add_decorative_floor() -> void:
	for index in range(9):
		_add_rect(Vector2(70 + index * 145, 575), Vector2(78, 150), Color(0.080, 0.135, 0.128), "FloorRack")
	_add_rect(Vector2(0, 690), Vector2(1600, 18), Color(0.13, 0.24, 0.22), "BottomLane")
	_add_rect(Vector2(0, 735), Vector2(1600, 28), Color(0.07, 0.15, 0.14), "DockLane")


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
	button.add_theme_font_size_override("font_size", 17)
	button.add_theme_color_override("font_color", Color(0.95, 0.99, 0.96))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.86, 0.45))
	_apply_button_style(button, Color(0.15, 0.25, 0.23), Color(0.33, 0.48, 0.42), 8)
	return button


func _apply_button_style(button: Button, bg_color: Color, border_color: Color, radius: int) -> void:
	button.add_theme_stylebox_override("normal", _button_style(bg_color, border_color, radius))
	button.add_theme_stylebox_override("hover", _button_style(bg_color.lightened(0.08), border_color.lightened(0.10), radius))
	button.add_theme_stylebox_override("pressed", _button_style(bg_color.darkened(0.08), border_color, radius))


func _button_style(bg_color: Color, border_color: Color, radius: int) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(radius)
	style.content_margin_left = 18
	style.content_margin_right = 18
	style.content_margin_top = 12
	style.content_margin_bottom = 12
	return style
