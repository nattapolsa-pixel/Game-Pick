extends Control

const PLAYER_SPEED := 235.0
const MAP_SIZE := Vector2(780, 520)
const PLAYER_SIZE := Vector2(28, 28)
const INTERACT_DISTANCE := 60.0
const JOY_SIZE := 150.0
const KNOB_SIZE := 64.0

const TH_UNIT_POOL := ["ชิ้น", "แพ็ค", "กล่อง", "ลัง", "ขวด", "ถุง"]
const MM_UNIT_POOL := ["ခု", "Pack", "ဘူး", "Carton", "အိတ်"]

var rack_catalog := [
	{"location": "A01-01", "sku": "WAT-600", "name_th": "น้ำดื่ม 600 ml", "name_mm": "ရေ 600 ml", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 24, "pos": Vector2(92, 76), "size": Vector2(96, 50)},
	{"location": "A01-02", "sku": "WAT-1500", "name_th": "น้ำดื่ม 1500 ml", "name_mm": "ရေ 1500 ml", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 18, "pos": Vector2(92, 148), "size": Vector2(96, 50)},
	{"location": "B01-01", "sku": "MILK-1L", "name_th": "นมจืด UHT 1 ลิตร", "name_mm": "UHT နို့ 1 လီတာ", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 15, "pos": Vector2(260, 76), "size": Vector2(96, 50)},
	{"location": "B01-02", "sku": "MILK-200", "name_th": "นมจืด UHT 200 ml", "name_mm": "UHT နို့ 200 ml", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 40, "pos": Vector2(260, 148), "size": Vector2(96, 50)},
	{"location": "C01-01", "sku": "NOOD-PORK-60", "name_th": "บะหมี่รสหมูสับ 60g", "name_mm": "ဝက်သားအရသာ ခေါက်ဆွဲ 60g", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 32, "pos": Vector2(428, 76), "size": Vector2(96, 50)},
	{"location": "C01-02", "sku": "NOOD-TOM-60", "name_th": "บะหมี่รสต้มยำ 60g", "name_mm": "တုန်ယမ်းအရသာ ခေါက်ဆွဲ 60g", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 28, "pos": Vector2(428, 148), "size": Vector2(96, 50)},
	{"location": "D01-01", "sku": "COF-BOX", "name_th": "กาแฟสำเร็จรูป 1 กล่อง", "name_mm": "ကော်ဖီ 1 ဘူး", "unit_th": "กล่อง", "unit_mm": "ဘူး", "available": 10, "pos": Vector2(596, 76), "size": Vector2(96, 50)},
	{"location": "D01-02", "sku": "COF-PCS", "name_th": "กาแฟซอง 1 ชิ้น", "name_mm": "Coffee 1 piece", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 60, "pos": Vector2(596, 148), "size": Vector2(96, 50)},
	{"location": "A02-01", "sku": "SODA-600", "name_th": "โซดา 600 ml", "name_mm": "ဆိုဒါ 600 ml", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 20, "pos": Vector2(92, 294), "size": Vector2(96, 50)},
	{"location": "B02-01", "sku": "TEA-500", "name_th": "ชาเขียว 500 ml", "name_mm": "လက်ဖက်ရည်စိမ်း 500 ml", "unit_th": "ชิ้น", "unit_mm": "ခု", "available": 18, "pos": Vector2(260, 294), "size": Vector2(96, 50)},
	{"location": "C02-01", "sku": "OIL-CTN", "name_th": "น้ำมันพืช 1 ลัง", "name_mm": "ဟင်းရွက်ဆီ 1 Carton", "unit_th": "ลัง", "unit_mm": "Carton", "available": 1, "pos": Vector2(428, 294), "size": Vector2(96, 50)},
	{"location": "D02-01", "sku": "SAUCE-700", "name_th": "ซอสปรุงรส 700 ml", "name_mm": "ဆော့စ် 700 ml", "unit_th": "ขวด", "unit_mm": "ဘူး", "available": 2, "pos": Vector2(596, 294), "size": Vector2(96, 50)},
	{"location": "C03-01", "sku": "RICE-5KG", "name_th": "ข้าวหอม 5 kg", "name_mm": "ဆန် 5 kg", "unit_th": "ถุง", "unit_mm": "အိတ်", "available": 5, "pos": Vector2(428, 388), "size": Vector2(96, 50)},
	{"location": "D03-01", "sku": "TISSUE-6", "name_th": "กระดาษทิชชู่ แพ็ค 6", "name_mm": "Tissue Pack 6", "unit_th": "แพ็ค", "unit_mm": "Pack", "available": 12, "pos": Vector2(596, 388), "size": Vector2(96, 50)}
]

var mission_catalog := {
	1: {
		"title_th": "1. พื้นฐาน: หยิบให้ถูก Location + SKU + จำนวน",
		"title_mm": "1. အခြေခံ: Location + SKU + Qty",
		"time": 100.0,
		"items": [
			{"location": "A01-01", "sku": "WAT-600", "qty": 6},
			{"location": "B01-01", "sku": "MILK-1L", "qty": 4},
			{"location": "C01-01", "sku": "NOOD-PORK-60", "qty": 8},
			{"location": "A02-01", "sku": "SODA-600", "qty": 5}
		]
	},
	2: {
		"title_th": "2. เลือกหน่วยให้ถูก (กล่อง/ลัง/แพ็ค/ถุง/ขวด)",
		"title_mm": "2. ယူနစ် မှန်အောင် ရွေးပါ",
		"time": 130.0,
		"items": [
			{"location": "D01-01", "sku": "COF-BOX", "qty": 2},
			{"location": "C02-01", "sku": "OIL-CTN", "qty": 1},
			{"location": "D03-01", "sku": "TISSUE-6", "qty": 3},
			{"location": "C03-01", "sku": "RICE-5KG", "qty": 2},
			{"location": "D02-01", "sku": "SAUCE-700", "qty": 2}
		]
	},
	3: {
		"title_th": "3. ของไม่พอ ต้องแจ้ง Short Pick",
		"title_mm": "3. Qty မလုံလောက်ပါက Short Pick",
		"time": 150.0,
		"items": [
			{"location": "C02-01", "sku": "OIL-CTN", "qty": 3},
			{"location": "D02-01", "sku": "SAUCE-700", "qty": 5},
			{"location": "C03-01", "sku": "RICE-5KG", "qty": 8},
			{"location": "D01-01", "sku": "COF-BOX", "qty": 3}
		]
	}
}

var rack_by_location := {}
var rack_nodes := {}
var mission_items: Array = []
var current_item_index := 0
var remaining_time := 0.0
var score := 0
var combo := 0
var best_combo := 0
var correct_count := 0
var wrong_count := 0
var is_finished := false
var player_start := Vector2(38, 458)
var active_location := ""
var pick_qty := 0
var selected_unit := ""
var joystick_base: Control
var joystick_knob: Panel
var joystick_vector := Vector2.ZERO
var joystick_active := false

var warehouse_area: Control
var player: ColorRect
var title_label: Label
var timer_label: Label
var score_label: Label
var combo_label: Label
var progress_label: Label
var picklist_label: Label
var coach_labels: Array = []
var station_info_label: Label
var qty_spin: SpinBox
var unit_row: HFlowContainer
var unit_buttons: Array = []
var confirm_button: Button
var short_button: Button
var feedback_label: Label
var target_marker: Label
var result_panel: PanelContainer
var result_label: Label
var stars_label: Label
var best_label: Label


func _ready() -> void:
	for rack in rack_catalog:
		rack_by_location[rack["location"]] = rack
	_build_ui()
	_start_mission()


func _process(delta: float) -> void:
	if is_finished:
		return

	remaining_time = maxf(0.0, remaining_time - delta)
	_update_timer()

	if remaining_time <= 0.0:
		_finish(false)
		return

	_move_player(delta)

	var near := _get_nearby_location()
	if near != "" and near != active_location:
		_activate_rack(near, false)


func _build_ui() -> void:
	var background := preload("res://scripts/vibrant_background.gd").new()
	background.calm = true
	add_child(background)

	var page := MarginContainer.new()
	page.set_anchors_preset(Control.PRESET_FULL_RECT)
	page.add_theme_constant_override("margin_left", 18)
	page.add_theme_constant_override("margin_top", 18)
	page.add_theme_constant_override("margin_right", 18)
	page.add_theme_constant_override("margin_bottom", 18)
	add_child(page)

	var columns := HBoxContainer.new()
	columns.add_theme_constant_override("separation", 16)
	page.add_child(columns)

	var play_column := VBoxContainer.new()
	play_column.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	play_column.size_flags_vertical = Control.SIZE_EXPAND_FILL
	play_column.add_theme_constant_override("separation", 10)
	columns.add_child(play_column)

	# HUD
	var hud_panel := PanelContainer.new()
	hud_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.10, 0.13, 0.14), Color(0.20, 0.29, 0.28)))
	play_column.add_child(hud_panel)

	var hud := HBoxContainer.new()
	hud.add_theme_constant_override("separation", 18)
	hud_panel.add_child(hud)

	title_label = _make_label("", 19, Color(0.88, 0.96, 0.94), true)
	title_label.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	hud.add_child(title_label)

	combo_label = _make_label("", 18, Color(1.0, 0.72, 0.32), true)
	combo_label.custom_minimum_size = Vector2(120, 0)
	hud.add_child(combo_label)

	timer_label = _make_label("00:00", 24, Color(1.0, 0.82, 0.34), true)
	timer_label.custom_minimum_size = Vector2(90, 0)
	hud.add_child(timer_label)

	score_label = _make_label("Score: 0", 18, Color(0.88, 0.96, 0.94), true)
	score_label.custom_minimum_size = Vector2(126, 0)
	hud.add_child(score_label)

	# Warehouse map
	var map_frame := PanelContainer.new()
	map_frame.custom_minimum_size = MAP_SIZE
	map_frame.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	map_frame.size_flags_vertical = Control.SIZE_EXPAND_FILL
	map_frame.add_theme_stylebox_override("panel", _panel_style(Color(0.13, 0.16, 0.15), Color(0.24, 0.36, 0.33)))
	play_column.add_child(map_frame)

	warehouse_area = Control.new()
	warehouse_area.name = "WarehouseArea"
	warehouse_area.custom_minimum_size = MAP_SIZE
	warehouse_area.clip_contents = true
	map_frame.add_child(warehouse_area)

	_build_warehouse_map()

	var controls_panel := PanelContainer.new()
	controls_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.08, 0.13, 0.13), Color(0.18, 0.30, 0.27)))
	play_column.add_child(controls_panel)

	var controls_label := _make_label(_t("เดิน: WASD/ลูกศร | หรือคลิกที่ rack เพื่อไปหยิบ | สีทอง = เป้าหมาย | สีเขียว = หยิบแล้ว", "WASD/Arrows or click a rack | Gold = target | Green = done"), 14, Color(0.84, 0.96, 0.90), true)
	controls_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	controls_panel.add_child(controls_label)

	# Side panel
	var side_scroll := ScrollContainer.new()
	side_scroll.custom_minimum_size = Vector2(384, 0)
	side_scroll.horizontal_scroll_mode = ScrollContainer.SCROLL_MODE_DISABLED
	columns.add_child(side_scroll)

	var side := VBoxContainer.new()
	side.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	side.add_theme_constant_override("separation", 10)
	side_scroll.add_child(side)

	progress_label = _make_label("", 16, Color(1.0, 0.80, 0.36), true)
	side.add_child(progress_label)

	# Coach steps
	var coach_panel := PanelContainer.new()
	coach_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.11, 0.16, 0.16), Color(0.26, 0.40, 0.36)))
	side.add_child(coach_panel)

	var coach_box := VBoxContainer.new()
	coach_box.add_theme_constant_override("separation", 3)
	coach_panel.add_child(coach_box)

	var coach_title := _make_label(_t("ทำตามนี้ทีละขั้น", "Steps"), 14, Color(0.80, 0.92, 0.88), true)
	coach_box.add_child(coach_title)

	var steps := [
		_t("1. อ่าน Pick List: Location / SKU / จำนวน / หน่วย", "1. Read the Pick List"),
		_t("2. ไปที่ rack เป้าหมาย - เดิน หรือ คลิก", "2. Go to the target rack"),
		_t("3. กรอกจำนวน + เลือกหน่วยให้ตรง Order", "3. Enter quantity + pick the unit"),
		_t("4. กด Confirm Pick หรือ Short Pick", "4. Press Confirm or Short Pick")
	]
	for step_text in steps:
		var lbl := _make_label(step_text, 14, Color(0.62, 0.72, 0.70), false)
		lbl.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
		lbl.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		coach_box.add_child(lbl)
		coach_labels.append(lbl)

	# Pick List card
	var picklist_panel := PanelContainer.new()
	picklist_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.14, 0.12, 0.06), Color(0.92, 0.70, 0.26)))
	side.add_child(picklist_panel)

	picklist_label = _make_label("", 16, Color(0.98, 0.96, 0.90), false)
	picklist_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	picklist_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	picklist_panel.add_child(picklist_label)

	# Pick Station
	var station_panel := PanelContainer.new()
	station_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.09, 0.12, 0.14), Color(0.22, 0.40, 0.46)))
	side.add_child(station_panel)

	var station := VBoxContainer.new()
	station.add_theme_constant_override("separation", 8)
	station_panel.add_child(station)

	var station_title := _make_label(_t("สถานีหยิบสินค้า", "Pick Station"), 15, Color(0.55, 0.90, 0.98), true)
	station.add_child(station_title)

	station_info_label = _make_label("", 15, Color(0.92, 0.97, 0.96), false)
	station_info_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	station_info_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	station.add_child(station_info_label)

	var qty_row := HBoxContainer.new()
	qty_row.add_theme_constant_override("separation", 10)
	station.add_child(qty_row)

	var qty_label := _make_label(_t("จำนวนที่หยิบ:", "Quantity:"), 15, Color(0.90, 0.96, 0.94), true)
	qty_row.add_child(qty_label)

	qty_spin = SpinBox.new()
	qty_spin.min_value = 0
	qty_spin.max_value = 99
	qty_spin.step = 1
	qty_spin.value = 0
	qty_spin.custom_minimum_size = Vector2(120, 36)
	qty_spin.add_theme_font_size_override("font_size", 18)
	qty_spin.value_changed.connect(_on_qty_changed)
	qty_row.add_child(qty_spin)

	var unit_label := _make_label(_t("หน่วย (เลือกให้ตรง):", "Unit:"), 15, Color(0.90, 0.96, 0.94), true)
	unit_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	station.add_child(unit_label)

	unit_row = HFlowContainer.new()
	station.add_child(unit_row)

	confirm_button = _make_button(_t("ยืนยันหยิบ (Confirm Pick)", "Confirm Pick"))
	_apply_button_style(confirm_button, Color(0.12, 0.40, 0.26), Color(0.34, 0.82, 0.56))
	confirm_button.pressed.connect(_submit.bind("pick"))
	station.add_child(confirm_button)

	short_button = _make_button(_t("แจ้งของไม่พอ (Short Pick)", "Short Pick"))
	_apply_button_style(short_button, Color(0.42, 0.30, 0.10), Color(0.95, 0.72, 0.24))
	short_button.pressed.connect(_submit.bind("short"))
	station.add_child(short_button)

	feedback_label = _make_label("", 15, Color(0.90, 0.95, 0.92), false)
	feedback_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_LEFT
	feedback_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	feedback_label.custom_minimum_size = Vector2(0, 60)
	side.add_child(feedback_label)

	var back_button := _make_button(_t("กลับหน้าเลือกภารกิจ", "Back to missions"))
	back_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MissionSelect.tscn"))
	side.add_child(back_button)

	if DisplayServer.is_touchscreen_available():
		_build_joystick()
	_build_result_panel()


func _build_result_panel() -> void:
	result_panel = PanelContainer.new()
	result_panel.visible = false
	result_panel.set_anchors_preset(Control.PRESET_CENTER)
	result_panel.custom_minimum_size = Vector2(520, 360)
	result_panel.offset_left = -260
	result_panel.offset_top = -180
	result_panel.offset_right = 260
	result_panel.offset_bottom = 180
	result_panel.add_theme_stylebox_override("panel", _panel_style(Color(0.08, 0.10, 0.11), Color(0.97, 0.74, 0.30)))
	add_child(result_panel)

	var result_box := VBoxContainer.new()
	result_box.alignment = BoxContainer.ALIGNMENT_CENTER
	result_box.add_theme_constant_override("separation", 12)
	result_panel.add_child(result_box)

	stars_label = _make_label("", 26, Color(1.0, 0.84, 0.35), true)
	result_box.add_child(stars_label)

	result_label = _make_label("", 19, Color(0.96, 0.98, 0.94), false)
	result_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_box.add_child(result_label)

	best_label = _make_label("", 15, Color(0.97, 0.82, 0.45), false)
	best_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	result_box.add_child(best_label)

	var result_buttons := HBoxContainer.new()
	result_buttons.alignment = BoxContainer.ALIGNMENT_CENTER
	result_buttons.add_theme_constant_override("separation", 8)
	result_box.add_child(result_buttons)

	var retry_button := _make_button(_t("เล่นอีกครั้ง", "Retry"))
	retry_button.pressed.connect(_restart_scene)
	result_buttons.add_child(retry_button)

	var mission_button := _make_button(_t("เลือกภารกิจ", "Missions"))
	mission_button.pressed.connect(func(): get_tree().change_scene_to_file("res://scenes/MissionSelect.tscn"))
	result_buttons.add_child(mission_button)


func _build_warehouse_map() -> void:
	_add_map_rect(Vector2.ZERO, MAP_SIZE, Color(0.12, 0.18, 0.17), "Floor")
	_add_map_rect(Vector2(24, 36), Vector2(732, 10), Color(0.24, 0.36, 0.32), "TopLane")
	_add_map_rect(Vector2(24, 226), Vector2(732, 18), Color(0.18, 0.29, 0.27), "MainAisle")
	_add_map_rect(Vector2(24, 466), Vector2(732, 32), Color(0.08, 0.22, 0.20), "DispatchLane")

	_add_map_label("PICK ZONE", Vector2(330, 10), Vector2(120, 24), 14, Color(0.82, 0.94, 0.89))
	_add_map_label("START", Vector2(20, 466), Vector2(84, 32), 13, Color(0.94, 1.0, 0.95))
	_add_map_label("A", Vector2(124, 46), Vector2(32, 22), 13, Color(0.58, 0.82, 0.72))
	_add_map_label("B", Vector2(292, 46), Vector2(32, 22), 13, Color(0.58, 0.82, 0.72))
	_add_map_label("C", Vector2(460, 46), Vector2(32, 22), 13, Color(0.58, 0.82, 0.72))
	_add_map_label("D", Vector2(628, 46), Vector2(32, 22), 13, Color(0.58, 0.82, 0.72))

	for rack in rack_catalog:
		var rack_node := ColorRect.new()
		rack_node.name = rack["location"]
		rack_node.color = Color(0.18, 0.36, 0.32, 0.92)
		rack_node.position = rack["pos"]
		rack_node.size = rack["size"]
		rack_node.mouse_filter = Control.MOUSE_FILTER_STOP
		var loc := str(rack["location"])
		rack_node.gui_input.connect(_on_rack_gui_input.bind(loc))
		warehouse_area.add_child(rack_node)
		rack_nodes[loc] = rack_node

		for slot_index in range(1, 4):
			_add_rack_slot_line(rack_node, slot_index)

		var rack_label := _make_label("%s\n%s" % [rack["location"], rack["sku"]], 10, Color(0.94, 1.0, 0.96), true)
		rack_label.set_anchors_preset(Control.PRESET_FULL_RECT)
		rack_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rack_node.add_child(rack_label)

	target_marker = _make_label(_t("มาหยิบตรงนี้", "Target"), 12, Color(0.08, 0.08, 0.05), true)
	target_marker.size = Vector2(100, 24)
	target_marker.visible = false
	target_marker.z_index = 20
	target_marker.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warehouse_area.add_child(target_marker)

	player = ColorRect.new()
	player.name = "PickerPlayer"
	player.color = GameState.player_color
	player.position = player_start
	player.size = PLAYER_SIZE
	player.z_index = 30
	player.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warehouse_area.add_child(player)

	var player_label := _make_label("P", 16, Color(0.05, 0.06, 0.06), true)
	player_label.set_anchors_preset(Control.PRESET_FULL_RECT)
	player_label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	player.add_child(player_label)

	player.pivot_offset = PLAYER_SIZE * 0.5
	var pulse := create_tween().set_loops()
	pulse.tween_property(player, "scale", Vector2(1.12, 1.12), 0.55).set_trans(Tween.TRANS_SINE)
	pulse.tween_property(player, "scale", Vector2(1.0, 1.0), 0.55).set_trans(Tween.TRANS_SINE)

	var marker_pulse := create_tween().set_loops()
	marker_pulse.tween_property(target_marker, "modulate:a", 0.45, 0.5)
	marker_pulse.tween_property(target_marker, "modulate:a", 1.0, 0.5)


func _start_mission() -> void:
	var mission = mission_catalog.get(GameState.current_mission, mission_catalog[1])
	mission_items = mission["items"].duplicate(true)
	current_item_index = 0
	remaining_time = mission["time"]
	score = 0
	combo = 0
	best_combo = 0
	correct_count = 0
	wrong_count = 0
	is_finished = false
	active_location = ""
	pick_qty = 0
	selected_unit = ""
	player.position = player_start
	result_panel.visible = false

	title_label.text = _language_text(mission, "title")
	feedback_label.text = _t("อ่าน Pick List แล้วไปที่ Location ให้ถูก จากนั้นกรอกจำนวน + เลือกหน่วยให้ตรง", "Read the list, go to the location, then enter qty + unit.")
	_refresh_all()


func _move_player(delta: float) -> void:
	var kb := Vector2.ZERO
	if Input.is_key_pressed(KEY_A) or Input.is_key_pressed(KEY_LEFT):
		kb.x -= 1.0
	if Input.is_key_pressed(KEY_D) or Input.is_key_pressed(KEY_RIGHT):
		kb.x += 1.0
	if Input.is_key_pressed(KEY_W) or Input.is_key_pressed(KEY_UP):
		kb.y -= 1.0
	if Input.is_key_pressed(KEY_S) or Input.is_key_pressed(KEY_DOWN):
		kb.y += 1.0

	var move := Vector2.ZERO
	if joystick_vector.length() > 0.18:
		move = joystick_vector
	elif kb != Vector2.ZERO:
		move = kb.normalized()
	else:
		return

	var new_position := player.position + move * PLAYER_SPEED * delta
	new_position.x = clampf(new_position.x, 8.0, MAP_SIZE.x - PLAYER_SIZE.x - 8.0)
	new_position.y = clampf(new_position.y, 42.0, MAP_SIZE.y - PLAYER_SIZE.y - 8.0)

	if not _would_hit_rack(new_position):
		player.position = new_position


func _would_hit_rack(new_position: Vector2) -> bool:
	var player_rect := Rect2(new_position, PLAYER_SIZE)
	for rack in rack_catalog:
		var rack_rect := Rect2(rack["pos"], rack["size"])
		if player_rect.intersects(rack_rect.grow(3.0)):
			return true
	return false


func _get_nearby_location() -> String:
	var player_center := player.position + PLAYER_SIZE * 0.5
	var closest_location := ""
	var closest_distance := 99999.0
	for rack in rack_catalog:
		var rect := Rect2(rack["pos"], rack["size"])
		var rack_center := rect.get_center()
		var distance := player_center.distance_to(rack_center)
		if distance < closest_distance and distance <= INTERACT_DISTANCE + maxf(rect.size.x, rect.size.y) * 0.5:
			closest_distance = distance
			closest_location = str(rack["location"])
	return closest_location


func _on_rack_gui_input(event: InputEvent, loc: String) -> void:
	if is_finished:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		_activate_rack(loc, true)


func _activate_rack(loc: String, move_player: bool) -> void:
	if is_finished:
		return
	active_location = loc
	var rack = rack_by_location[loc]

	if move_player:
		var target_pos: Vector2 = rack["pos"] + Vector2(rack["size"].x * 0.5 - PLAYER_SIZE.x * 0.5, rack["size"].y + 8.0)
		target_pos.x = clampf(target_pos.x, 8.0, MAP_SIZE.x - PLAYER_SIZE.x - 8.0)
		target_pos.y = clampf(target_pos.y, 42.0, MAP_SIZE.y - PLAYER_SIZE.y - 8.0)
		player.position = target_pos

	pick_qty = 0
	qty_spin.value = 0
	selected_unit = ""
	_build_unit_chips(_t(rack["unit_th"], rack["unit_mm"]))
	_refresh_station()
	_refresh_coach()


func _build_unit_chips(correct_unit: String) -> void:
	for b in unit_buttons:
		b.queue_free()
	unit_buttons.clear()

	var pool: Array = (TH_UNIT_POOL if GameState.current_language == "TH" else MM_UNIT_POOL).duplicate()
	pool.erase(correct_unit)
	pool.shuffle()

	var options := [correct_unit]
	for i in range(min(3, pool.size())):
		options.append(pool[i])
	options.shuffle()

	for u in options:
		var chip := _make_chip(u)
		chip.pressed.connect(_select_unit.bind(u))
		unit_row.add_child(chip)
		unit_buttons.append(chip)
	_restyle_chips()


func _clear_unit_chips() -> void:
	for b in unit_buttons:
		b.queue_free()
	unit_buttons.clear()


func _select_unit(u: String) -> void:
	selected_unit = u
	_restyle_chips()
	_refresh_coach()


func _restyle_chips() -> void:
	for b in unit_buttons:
		if b.text == selected_unit:
			_apply_button_style(b, Color(0.14, 0.42, 0.46), Color(0.32, 0.86, 0.98))
			b.add_theme_color_override("font_color", Color(1.0, 1.0, 1.0))
		else:
			_apply_button_style(b, Color(0.16, 0.24, 0.28), Color(0.30, 0.44, 0.50))
			b.add_theme_color_override("font_color", Color(0.92, 0.98, 0.95))


func _on_qty_changed(value: float) -> void:
	pick_qty = int(value)
	_refresh_coach()


func _submit(action: String) -> void:
	if is_finished:
		return

	if active_location == "":
		_flash_feedback(_t("ยังไม่ได้เลือก rack - เดินไปหา หรือคลิกที่ rack เป้าหมายก่อน", "Pick a rack first."), false)
		return

	var item := _current_item()
	var rack = rack_by_location[active_location]

	if active_location != item["location"]:
		_register_wrong(_t("Location ผิด! ตอนนี้อยู่ที่ %s แต่ Order ต้องไป %s" % [active_location, item["location"]], "Wrong location: go to %s" % item["location"]))
		return

	if selected_unit == "":
		_flash_feedback(_t("เลือกหน่วยก่อน", "Choose a unit first."), false)
		return

	if pick_qty <= 0:
		_flash_feedback(_t("กรอกจำนวนที่จะหยิบก่อน", "Enter a quantity first."), false)
		return

	var required := int(item["qty"])
	var available := int(rack["available"])
	var correct_unit := _t(rack["unit_th"], rack["unit_mm"])
	var correct_action := "pick" if available >= required else "short"
	var correct_qty := required if available >= required else available

	var action_ok := action == correct_action
	var qty_ok := pick_qty == correct_qty
	var unit_ok := selected_unit == correct_unit

	if action_ok and qty_ok and unit_ok:
		_correct(action, correct_qty, correct_unit)
	else:
		var problems: Array = []
		if not action_ok:
			if correct_action == "short":
				problems.append(_t("ของมีแค่ %s แต่ Order ต้องการ %s จึงต้องกด \"แจ้งของไม่พอ (Short Pick)\"" % [available, required], "Stock %s < needed %s: use Short Pick" % [available, required]))
			else:
				problems.append(_t("สต๊อกพอ (%s ชิ้น) จึงต้องกด \"ยืนยันหยิบ (Confirm Pick)\"" % available, "Stock is enough: use Confirm Pick"))
		if not qty_ok:
			problems.append(_t("จำนวนที่ถูกคือ %s (คุณกรอก %s)" % [correct_qty, pick_qty], "Correct qty is %s (you put %s)" % [correct_qty, pick_qty]))
		if not unit_ok:
			problems.append(_t("หน่วยที่ถูกคือ \"%s\" (คุณเลือก \"%s\")" % [correct_unit, selected_unit], "Correct unit is \"%s\"" % correct_unit))
		var msg := ""
		for p in problems:
			if msg != "":
				msg += "\n"
			msg += "- " + str(p)
		_register_wrong(msg)


func _correct(action: String, qty: int, unit: String) -> void:
	correct_count += 1
	combo += 1
	best_combo = maxi(best_combo, combo)

	var mission_time: float = float(mission_catalog[GameState.current_mission]["time"])
	var speed_bonus := int((remaining_time / mission_time) * 40.0)
	var combo_bonus := (combo - 1) * 15
	var gained := 100 + speed_bonus + combo_bonus
	score += gained

	if rack_nodes.has(active_location):
		rack_nodes[active_location].color = Color(0.20, 0.55, 0.36)

	var verb := _t("หยิบ", "Pick") if action == "pick" else _t("แจ้งของไม่พอ Short Pick", "Short Pick")
	_flash_feedback(_t("ถูกต้อง! %s %s %s   (+%s | combo x%s)" % [verb, qty, unit, gained, combo], "Correct! +%s (combo x%s)" % [gained, combo]), true)
	_flash_node(score_label, Color(0.55, 1.0, 0.62))

	current_item_index += 1
	active_location = ""
	pick_qty = 0
	selected_unit = ""
	_clear_unit_chips()

	if current_item_index >= mission_items.size():
		score += int(remaining_time * 2.0)
		_finish(true)
	else:
		_refresh_all()


func _register_wrong(message: String) -> void:
	wrong_count += 1
	combo = 0
	score = maxi(0, score - 30)
	_flash_feedback(_t("ยังไม่ถูก:\n", "Not yet:\n") + message, false)
	_update_hud()
	_refresh_coach()


func _flash_feedback(text: String, good: bool) -> void:
	feedback_label.text = text
	if good:
		feedback_label.add_theme_color_override("font_color", Color(0.55, 0.95, 0.62))
	else:
		feedback_label.add_theme_color_override("font_color", Color(1.0, 0.55, 0.48))


func _finish(completed: bool) -> void:
	is_finished = true
	GameState.score = score

	var attempts := correct_count + wrong_count
	var accuracy := 100 if attempts == 0 else int(round(float(correct_count) / float(attempts) * 100.0))

	var stars := 0
	if completed:
		if accuracy >= 90:
			stars = 3
		elif accuracy >= 70:
			stars = 2
		else:
			stars = 1

	var grade := _t("ลองใหม่อีกครั้ง", "Try again")
	if stars == 3:
		grade = _t("เยี่ยมมาก!", "Excellent!")
	elif stars == 2:
		grade = _t("ดีมาก", "Great")
	elif stars == 1:
		grade = _t("ผ่าน", "Pass")
	stars_label.text = _t("%s / 3 ดาว - %s" % [stars, grade], "%s / 3 stars - %s" % [stars, grade])

	var is_new_best := GameState.register_score(GameState.current_mission, score)
	var best := GameState.get_best_score(GameState.current_mission)

	if completed:
		result_label.text = _t(
			"จบภารกิจ!\nคะแนน: %s\nความแม่นยำ: %s%%\nถูก %s รายการ | ผิด %s ครั้ง\nคอมโบสูงสุด: x%s" % [score, accuracy, correct_count, wrong_count, best_combo],
			"Mission complete!\nScore: %s\nAccuracy: %s%%\nCorrect %s | Wrong %s\nBest combo: x%s" % [score, accuracy, correct_count, wrong_count, best_combo]
		)
	else:
		result_label.text = _t(
			"หมดเวลา!\nทำได้ %s/%s รายการ\nคะแนน: %s\nความแม่นยำ: %s%%" % [current_item_index, mission_items.size(), score, accuracy],
			"Time up!\nDone %s/%s\nScore: %s\nAccuracy: %s%%" % [current_item_index, mission_items.size(), score, accuracy]
		)

	if is_new_best:
		best_label.text = _t("สถิติใหม่! Best: %s คะแนน" % best, "New best: %s" % best)
	else:
		best_label.text = _t("Best ภารกิจนี้: %s คะแนน" % best, "Best: %s" % best)

	result_panel.visible = true
	result_panel.pivot_offset = Vector2(260, 180)
	result_panel.scale = Vector2(0.85, 0.85)
	var rt := create_tween()
	rt.tween_property(result_panel, "scale", Vector2(1.0, 1.0), 0.3).set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)


func _refresh_all() -> void:
	_update_picklist()
	_update_hud()
	_update_timer()
	_update_rack_highlight()
	_refresh_station()
	_refresh_coach()


func _update_picklist() -> void:
	if current_item_index >= mission_items.size():
		return
	var item := _current_item()
	var rack = rack_by_location[item["location"]]
	picklist_label.text = _t(
		"PICK LIST\nLocation:  %s\nSKU:  %s\nสินค้า:  %s\nต้องหยิบ:  %s %s" % [item["location"], item["sku"], rack["name_th"], item["qty"], rack["unit_th"]],
		"PICK LIST\nLocation: %s\nSKU: %s\nItem: %s\nNeed: %s %s" % [item["location"], item["sku"], rack["name_mm"], item["qty"], rack["unit_mm"]]
	)


func _update_hud() -> void:
	score_label.text = "Score: %s" % score
	progress_label.text = _t("รายการที่ %s / %s" % [mini(current_item_index + 1, mission_items.size()), mission_items.size()], "Item %s / %s" % [mini(current_item_index + 1, mission_items.size()), mission_items.size()])
	if combo >= 2:
		combo_label.text = "Combo x%s" % combo
	else:
		combo_label.text = ""


func _update_timer() -> void:
	timer_label.text = _format_time(remaining_time)
	if remaining_time <= 15.0:
		timer_label.add_theme_color_override("font_color", Color(1.0, 0.35, 0.28))
	else:
		timer_label.add_theme_color_override("font_color", Color(1.0, 0.82, 0.34))


func _refresh_station() -> void:
	if current_item_index >= mission_items.size():
		return
	var item := _current_item()

	if active_location == "":
		station_info_label.text = _t("ยังไม่ได้เลือก rack\nเดินไปหา (WASD) หรือคลิกที่ rack เป้าหมาย (สีทอง)", "No rack selected. Walk or click the gold rack.")
		confirm_button.disabled = true
		short_button.disabled = true
		qty_spin.editable = false
		return

	confirm_button.disabled = false
	short_button.disabled = false
	qty_spin.editable = true

	var rack = rack_by_location[active_location]
	var head := ""
	if active_location == item["location"]:
		head = _t("ตรงกับ Order (ถูกที่แล้ว)", "Matches order")
	else:
		head = _t("ไม่ตรงกับ Order - ต้องไป %s" % item["location"], "Wrong - go to %s" % item["location"])

	station_info_label.text = _t(
		"%s\nrack นี้: %s | SKU %s\nสินค้า: %s\nสต๊อกคงเหลือ: %s %s" % [head, active_location, rack["sku"], rack["name_th"], rack["available"], rack["unit_th"]],
		"%s\nRack: %s | SKU %s\nStock: %s %s" % [head, active_location, rack["sku"], rack["available"], rack["unit_mm"]]
	)


func _refresh_coach() -> void:
	var step := 1
	if current_item_index < mission_items.size():
		var item := _current_item()
		if active_location == "" or active_location != item["location"]:
			step = 2
		elif pick_qty <= 0 or selected_unit == "":
			step = 3
		else:
			step = 4

	for i in range(coach_labels.size()):
		var lbl: Label = coach_labels[i]
		if i + 1 == step:
			lbl.add_theme_color_override("font_color", Color(1.0, 0.84, 0.35))
		else:
			lbl.add_theme_color_override("font_color", Color(0.60, 0.70, 0.68))


func _update_rack_highlight() -> void:
	for rack in rack_catalog:
		rack_nodes[str(rack["location"])].color = Color(0.18, 0.36, 0.32, 0.92)

	for i in range(current_item_index):
		var done_loc := str(mission_items[i]["location"])
		if rack_nodes.has(done_loc):
			rack_nodes[done_loc].color = Color(0.20, 0.55, 0.36)

	if current_item_index < mission_items.size():
		var target_loc := str(_current_item()["location"])
		if rack_nodes.has(target_loc):
			rack_nodes[target_loc].color = Color(0.96, 0.66, 0.18, 1.0)
			target_marker.visible = true
			target_marker.position = rack_nodes[target_loc].position + Vector2(-2, -28)
	else:
		target_marker.visible = false


func _build_joystick() -> void:
	joystick_base = Control.new()
	joystick_base.name = "Joystick"
	joystick_base.anchor_top = 1.0
	joystick_base.anchor_bottom = 1.0
	joystick_base.offset_left = 24.0
	joystick_base.offset_right = 24.0 + JOY_SIZE
	joystick_base.offset_top = -24.0 - JOY_SIZE
	joystick_base.offset_bottom = -24.0
	joystick_base.mouse_filter = Control.MOUSE_FILTER_STOP
	add_child(joystick_base)

	var ring := Panel.new()
	ring.set_anchors_preset(Control.PRESET_FULL_RECT)
	ring.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var ring_style := StyleBoxFlat.new()
	ring_style.bg_color = Color(0.10, 0.16, 0.20, 0.55)
	ring_style.set_corner_radius_all(int(JOY_SIZE * 0.5))
	ring_style.set_border_width_all(2)
	ring_style.border_color = Color(0.35, 0.62, 0.72, 0.85)
	ring.add_theme_stylebox_override("panel", ring_style)
	joystick_base.add_child(ring)

	var hint := _make_label(_t("ลากเพื่อเดิน", "Drag to move"), 12, Color(0.70, 0.85, 0.90), true)
	hint.set_anchors_preset(Control.PRESET_FULL_RECT)
	hint.mouse_filter = Control.MOUSE_FILTER_IGNORE
	hint.modulate = Color(1.0, 1.0, 1.0, 0.5)
	joystick_base.add_child(hint)

	joystick_knob = Panel.new()
	joystick_knob.size = Vector2(KNOB_SIZE, KNOB_SIZE)
	joystick_knob.mouse_filter = Control.MOUSE_FILTER_IGNORE
	var knob_style := StyleBoxFlat.new()
	knob_style.bg_color = Color(0.30, 0.64, 0.74, 0.92)
	knob_style.set_corner_radius_all(int(KNOB_SIZE * 0.5))
	knob_style.set_border_width_all(2)
	knob_style.border_color = Color(0.62, 0.92, 1.0, 0.95)
	joystick_knob.add_theme_stylebox_override("panel", knob_style)
	joystick_base.add_child(joystick_knob)
	_reset_knob()


func _reset_knob() -> void:
	joystick_vector = Vector2.ZERO
	if joystick_knob != null:
		joystick_knob.position = Vector2(JOY_SIZE, JOY_SIZE) * 0.5 - Vector2(KNOB_SIZE, KNOB_SIZE) * 0.5


func _update_knob(local_pos: Vector2) -> void:
	var center := Vector2(JOY_SIZE, JOY_SIZE) * 0.5
	var offset := local_pos - center
	var max_r := JOY_SIZE * 0.5 - KNOB_SIZE * 0.5
	if offset.length() > max_r:
		offset = offset.normalized() * max_r
	joystick_knob.position = center + offset - Vector2(KNOB_SIZE, KNOB_SIZE) * 0.5
	joystick_vector = offset / max_r


func _input(event: InputEvent) -> void:
	if joystick_base == null or is_finished:
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		if event.pressed:
			if joystick_base.get_global_rect().has_point(event.position):
				joystick_active = true
				_update_knob(joystick_base.get_local_mouse_position())
		elif joystick_active:
			joystick_active = false
			_reset_knob()
	elif event is InputEventMouseMotion and joystick_active:
		_update_knob(joystick_base.get_local_mouse_position())


func _current_item() -> Dictionary:
	return mission_items[current_item_index]


func _restart_scene() -> void:
	get_tree().reload_current_scene()


func _format_time(seconds: float) -> String:
	var total := int(ceil(seconds))
	var minutes := int(total / 60)
	var secs := total % 60
	return "%02d:%02d" % [minutes, secs]


func _language_text(data: Dictionary, key: String) -> String:
	if GameState.current_language == "TH":
		return data.get("%s_th" % key, "")
	return data.get("%s_mm" % key, data.get("%s_th" % key, ""))


func _t(th_text: String, mm_text: String) -> String:
	if GameState.current_language == "TH":
		return th_text
	return mm_text


func _add_map_rect(pos: Vector2, rect_size: Vector2, color: Color, node_name: String) -> ColorRect:
	var rect := ColorRect.new()
	rect.name = node_name
	rect.position = pos
	rect.size = rect_size
	rect.color = color
	rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warehouse_area.add_child(rect)
	return rect


func _add_map_label(text: String, pos: Vector2, rect_size: Vector2, font_size: int, color: Color) -> void:
	var label := _make_label(text, font_size, color, true)
	label.position = pos
	label.size = rect_size
	label.mouse_filter = Control.MOUSE_FILTER_IGNORE
	warehouse_area.add_child(label)


func _add_rack_slot_line(rack_node: ColorRect, slot_index: int) -> void:
	var line := ColorRect.new()
	line.color = Color(0.10, 0.24, 0.22, 0.72)
	line.position = Vector2(8, slot_index * 12)
	line.size = Vector2(maxf(12.0, rack_node.size.x - 16.0), 2)
	line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	rack_node.add_child(line)


func _flash_node(node: CanvasItem, flash_color: Color) -> void:
	node.modulate = flash_color
	var tw := create_tween()
	tw.tween_property(node, "modulate", Color(1.0, 1.0, 1.0, 1.0), 0.45)


func _make_label(text: String, font_size: int, color: Color, bold: bool) -> Label:
	var label := Label.new()
	label.text = text
	label.add_theme_font_size_override("font_size", font_size)
	label.add_theme_color_override("font_color", color)
	if bold:
		label.add_theme_color_override("font_shadow_color", Color(0.0, 0.0, 0.0, 0.42))
		label.add_theme_constant_override("shadow_offset_x", 1)
		label.add_theme_constant_override("shadow_offset_y", 1)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER if bold else HORIZONTAL_ALIGNMENT_LEFT
	label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	return label


func _make_button(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(0, 42)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 16)
	button.add_theme_color_override("font_color", Color(0.95, 0.99, 0.96))
	button.add_theme_color_override("font_hover_color", Color(1.0, 0.86, 0.45))
	_apply_button_style(button, Color(0.15, 0.25, 0.23), Color(0.33, 0.48, 0.42))
	return button


func _make_chip(text: String) -> Button:
	var button := Button.new()
	button.text = text
	button.custom_minimum_size = Vector2(78, 34)
	button.focus_mode = Control.FOCUS_NONE
	button.add_theme_font_size_override("font_size", 15)
	button.add_theme_color_override("font_color", Color(0.92, 0.98, 0.95))
	_apply_button_style(button, Color(0.16, 0.24, 0.28), Color(0.30, 0.44, 0.50))
	return button


func _apply_button_style(button: Button, bg_color: Color, border_color: Color) -> void:
	button.add_theme_stylebox_override("normal", _button_style(bg_color, border_color))
	button.add_theme_stylebox_override("hover", _button_style(bg_color.lightened(0.08), border_color.lightened(0.10)))
	button.add_theme_stylebox_override("pressed", _button_style(bg_color.darkened(0.08), border_color))
	button.add_theme_stylebox_override("disabled", _button_style(bg_color.darkened(0.35), border_color.darkened(0.35)))


func _panel_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 10
	style.content_margin_bottom = 10
	return style


func _button_style(bg_color: Color, border_color: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = bg_color
	style.border_color = border_color
	style.set_border_width_all(2)
	style.set_corner_radius_all(8)
	style.content_margin_left = 12
	style.content_margin_right = 12
	style.content_margin_top = 8
	style.content_margin_bottom = 8
	return style
