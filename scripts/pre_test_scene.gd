extends Control

var title_label: Label
var scenario_label: Label
var feedback_label: Label
var progress_label: Label
var choice_buttons: Array[Button] = []
var next_button: Button
var mission_button: Button

var current_index := 0
var correct_count := 0
var locked := false

var questions := [
	{
		"scenario_th": "Order ต้องการน้ำดื่ม 600 ml ที่ Location A01-01\nแต่คุณยืนอยู่ A01-02 ซึ่งเป็นน้ำดื่ม 1500 ml",
		"scenario_mm": "Order သည် ရေ 600 ml / A01-01 လိုအပ်သည်။ သင်သည် A01-02 ရေ 1500 ml အနီးတွင်ရှိသည်။",
		"choices_th": ["Confirm Pick ทันที", "ย้ายไป Location A01-01 ก่อน", "แจ้ง Short Pick"],
		"choices_mm": ["Confirm Pick", "A01-01 သို့အရင်သွားမည်", "Short Pick แจ้งမည်"],
		"correct": 1,
		"explain_th": "ถูกต้อง ต้องยืนยันจาก Location และ SKU ที่ตรงกับ Order ก่อน",
		"explain_mm": "မှန်ပါသည်။ Location နှင့် SKU ကို Order အတိုင်းစစ်ပါ။"
	},
	{
		"scenario_th": "Order ระบุ กาแฟ 1 กล่อง\nแต่ที่หยิบมาเป็นกาแฟซอง 1 ชิ้น",
		"scenario_mm": "Order တွင် Coffee 1 box ဟုပါသည်။ သင်ယူလာသည်မှာ Coffee 1 piece ဖြစ်သည်။",
		"choices_th": ["Confirm เพราะเป็นกาแฟเหมือนกัน", "เปลี่ยนเป็นหน่วยกล่องให้ถูก", "หยิบสินค้าอื่นแทน"],
		"choices_mm": ["Coffee ဖြစ်လို့ Confirm", "Box unit ကိုမှန်အောင်ရွေးမည်", "အခြားပစ္စည်းယူမည်"],
		"correct": 1,
		"explain_th": "ถูกต้อง ต้องดูหน่วยสินค้าให้ตรง เช่น ชิ้น/แพ็ค/กล่อง/ลัง",
		"explain_mm": "မှန်ပါသည်။ Unit ကိုသေချာစစ်ပါ။"
	},
	{
		"scenario_th": "Order ต้องการน้ำมันพืช 2 ลัง\nแต่ Location มีของจริง 1 ลัง",
		"scenario_mm": "Order သည် Oil 2 cartons လိုအပ်သည်။ Location တွင် 1 carton သာရှိသည်။",
		"choices_th": ["Confirm 2 ลังไปก่อน", "แจ้ง Short Pick", "หยิบสินค้าอื่นแทน"],
		"choices_mm": ["2 cartons Confirm", "Short Pick แจ้งမည်", "အစားထိုးပစ္စည်းယူမည်"],
		"correct": 1,
		"explain_th": "ถูกต้อง สินค้าไม่พอต้องแจ้ง Short Pick ตามขั้นตอน",
		"explain_mm": "မှန်ပါသည်။ Qty မလုံလောက်ပါက Short Pick แจ้งပါ။"
	}
]


func _ready() -> void:
	_build_ui()
	_load_question()


func _build_ui() -> void:
	_add_background()
	_add_rect(Vector2(0, 0), Vector2(1600, 96), Color(0.05, 0.09, 0.13, 0.66), "Header")
	_add_rect(Vector2(0, 96), Vector2(1600, 4), Color(0.22, 0.86, 0.98), "Accent")

	var scroll := ScrollContainer.new()
	scroll.set_anchors_preset(Control.PRESET_FULL_RECT)
	scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	add_child(scroll)

	var page := CenterContainer.new()
	page.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	page.size_flags_vertical = Control.SIZE_EXPAND_FILL
	scroll.add_child(page)

	var card := PanelContainer.new()
	card.custom_minimum_size = Vector2(760, 560)
	card.add_theme_stylebox_override("panel", _panel_style(Color(0.085, 0.115, 0.120, 0.98), Color(0.90, 0.64, 0.22), 14, 2))
	page.add_child(card)

	var box := VBoxContainer.new()
	box.add_theme_constant_override("separation", 14)
	card.add_child(box)

	title_label = _make_label(_t("Pre-Test ก่อนเล่น", "Pre-Test"), 36, Color(0.95, 0.99, 0.96), true)
	box.add_child(title_label)

	progress_label = _make_label("", 16, Color(1.0, 0.78, 0.34), true)
	box.add_child(progress_label)

	scenario_label = _make_label("", 20, Color(0.94, 0.99, 0.96), false)
	scenario_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	scenario_label.custom_minimum_size = Vector2(680, 120)
	box.add_child(scenario_label)

	for index in range(3):
		var button := _make_button("")
		button.custom_minimum_size = Vector2(680, 48)
		button.pressed.connect(func(choice_index := index): _choose(choice_index))
		choice_buttons.append(button)
		box.add_child(button)

	feedback_label = _make_label("", 17, Color(0.77, 0.90, 0.84), false)
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feedback_label.custom_minimum_size = Vector2(680, 78)
	box.add_child(feedback_label)

	var nav := HBoxContainer.new()
	nav.alignment = BoxContainer.ALIGNMENT_CENTER
	nav.add_theme_constant_override("separation", 10)
	box.add_child(nav)

	next_button = _make_button(_t("ข้อต่อไป", "Next"))
	next_button.visible = false
	next_button.pressed.connect(_next)
	nav.add_child(next_button)

	mission_button = _make_button(_t("เลือกภารกิจ", "Choose Mission"))
	mission_button.visible = false
	mission_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MissionSelect.tscn"))
	nav.add_child(mission_button)

	var back_button := _make_button(_t("กลับหน้าหลัก", "Main Menu"))
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/main_menu.tscn"))
	nav.add_child(back_button)


func _load_question() -> void:
	locked = false
	var question = questions[current_index]
	progress_label.text = _t("ข้อที่ %s/%s" % [current_index + 1, questions.size()], "Question %s/%s" % [current_index + 1, questions.size()])
	scenario_label.text = _language_value(question, "scenario")
	feedback_label.text = _t("เลือกคำตอบที่ควรทำในงาน Pick จริง", "Choose the correct action")
	next_button.visible = false
	mission_button.visible = false

	var choices: Array = question["choices_th"] if GameState.current_language == "TH" else question["choices_mm"]
	for index in range(choice_buttons.size()):
		choice_buttons[index].text = choices[index]
		choice_buttons[index].disabled = false


func _choose(choice_index: int) -> void:
	if locked:
		return

	locked = true
	var question = questions[current_index]
	var correct := int(question["correct"])

	for button in choice_buttons:
		button.disabled = true

	if choice_index == correct:
		correct_count += 1
		feedback_label.text = _t("ถูกต้อง\n", "Correct\n") + _language_value(question, "explain")
	else:
		feedback_label.text = _t("ยังไม่ถูก\n", "Not yet\n") + _language_value(question, "explain")

	if current_index >= questions.size() - 1:
		var passed := correct_count >= 2
		feedback_label.text += "\n\n" + _t("ผล Pre-Test: %s/%s - %s" % [correct_count, questions.size(), "ผ่าน" if passed else "ควรทบทวนคู่มืออีกครั้ง"], "Pre-Test result: %s/%s" % [correct_count, questions.size()])
		mission_button.visible = true
	else:
		next_button.visible = true


func _next() -> void:
	current_index += 1
	_load_question()


func _language_value(data: Dictionary, key: String) -> String:
	if GameState.current_language == "TH":
		return data["%s_th" % key]
	return data["%s_mm" % key]


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
	style.content_margin_left = 28
	style.content_margin_right = 28
	style.content_margin_top = 26
	style.content_margin_bottom = 26
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
