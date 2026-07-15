extends Control
## Reusable, self-contained vibrant animated backdrop.
##
## Add it as the FIRST child of a scene and it fills the whole screen,
## sits behind the rest of the UI (z_index -20) and never eats mouse input.
##
## Look: deep gradient + neon glow blobs + a receding floor grid + drifting motes.
## Set `calm = true` BEFORE add_child() on busy gameplay scenes to tone it down.

var calm: bool = false

const DESIGN_SIZE := Vector2(1600.0, 900.0)

var _time: float = 0.0
var _glows: Array = []
var _motes: Array = []


func _ready() -> void:
	name = "VibrantBackground"
	set_anchors_preset(Control.PRESET_FULL_RECT)
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	z_index = -20
	_build()


func _build() -> void:
	_add_backdrop()
	_add_glows()
	_add_floor_grid()
	_add_motes(20 if calm else 46)


func _process(delta: float) -> void:
	_time += delta

	for glow in _glows:
		var node: TextureRect = glow["node"]
		node.modulate.a = glow["base"] * (0.72 + 0.28 * sin(_time * glow["speed"] + glow["phase"]))

	for mote in _motes:
		var node: ColorRect = mote["node"]
		mote["y"] += mote["vy"] * delta
		mote["cx"] += mote["vx"] * delta
		if mote["y"] < -12.0:
			mote["y"] = DESIGN_SIZE.y + 12.0
			mote["cx"] = randf() * DESIGN_SIZE.x
		if mote["cx"] < -24.0:
			mote["cx"] = DESIGN_SIZE.x + 24.0
		elif mote["cx"] > DESIGN_SIZE.x + 24.0:
			mote["cx"] = -24.0
		node.position = Vector2(mote["cx"] + sin(_time * 0.7 + mote["phase"]) * mote["amp"], mote["y"])


func _add_backdrop() -> void:
	var backdrop := TextureRect.new()
	backdrop.texture = _linear_texture(Color(0.07, 0.05, 0.18), Color(0.02, 0.09, 0.13))
	backdrop.set_anchors_preset(Control.PRESET_FULL_RECT)
	backdrop.stretch_mode = TextureRect.STRETCH_SCALE
	backdrop.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(backdrop)


func _add_glows() -> void:
	var intensity := 0.6 if calm else 1.0
	_add_glow(Vector2(-180.0, -160.0), Vector2(780.0, 780.0), Color(0.15, 0.85, 0.98), 0.24 * intensity)
	_add_glow(Vector2(1080.0, -220.0), Vector2(860.0, 860.0), Color(0.98, 0.28, 0.60), 0.22 * intensity)
	_add_glow(Vector2(560.0, 540.0), Vector2(940.0, 940.0), Color(1.0, 0.68, 0.16), 0.18 * intensity)
	_add_glow(Vector2(120.0, 500.0), Vector2(720.0, 720.0), Color(0.42, 0.95, 0.55), 0.14 * intensity)


func _add_glow(pos: Vector2, glow_size: Vector2, color: Color, alpha: float) -> void:
	var glow := TextureRect.new()
	glow.texture = _radial_texture(color)
	glow.position = pos
	glow.size = glow_size
	glow.stretch_mode = TextureRect.STRETCH_SCALE
	glow.mouse_filter = Control.MOUSE_FILTER_IGNORE
	glow.modulate = Color(1.0, 1.0, 1.0, alpha)
	add_child(glow)
	_glows.append({
		"node": glow,
		"base": alpha,
		"phase": randf() * TAU,
		"speed": randf_range(0.45, 1.05),
	})


func _add_floor_grid() -> void:
	var horizon := 648.0

	var horizon_line := ColorRect.new()
	horizon_line.color = Color(0.32, 0.88, 0.98, 0.55)
	horizon_line.position = Vector2(0.0, horizon)
	horizon_line.size = Vector2(DESIGN_SIZE.x, 3.0)
	horizon_line.mouse_filter = Control.MOUSE_FILTER_IGNORE
	add_child(horizon_line)

	for i in range(1, 8):
		var y := horizon + float(i * i) * 5.4
		var line := ColorRect.new()
		line.color = Color(0.20, 0.60, 0.68, clampf(0.34 - i * 0.035, 0.05, 0.34))
		line.position = Vector2(0.0, y)
		line.size = Vector2(DESIGN_SIZE.x, 2.0)
		line.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(line)

	for i in range(0, 17):
		var v := ColorRect.new()
		v.color = Color(0.20, 0.55, 0.62, 0.14)
		v.position = Vector2(i * 100.0, horizon)
		v.size = Vector2(2.0, DESIGN_SIZE.y - horizon)
		v.mouse_filter = Control.MOUSE_FILTER_IGNORE
		add_child(v)


func _add_motes(count: int) -> void:
	var tints := [
		Color(0.55, 0.95, 1.0),
		Color(1.0, 0.82, 0.42),
		Color(1.0, 0.52, 0.76),
		Color(0.62, 1.0, 0.72),
	]
	for i in range(count):
		var mote := ColorRect.new()
		var s := randf_range(2.0, 5.0)
		mote.size = Vector2(s, s)
		var tint: Color = tints[i % tints.size()]
		mote.color = Color(tint.r, tint.g, tint.b, randf_range(0.25, 0.7))
		mote.mouse_filter = Control.MOUSE_FILTER_IGNORE
		var cx := randf() * DESIGN_SIZE.x
		var y := randf() * DESIGN_SIZE.y
		mote.position = Vector2(cx, y)
		add_child(mote)
		_motes.append({
			"node": mote,
			"cx": cx,
			"y": y,
			"vx": randf_range(-9.0, 9.0),
			"vy": randf_range(-30.0, -10.0),
			"amp": randf_range(6.0, 18.0),
			"phase": randf() * TAU,
		})


func _linear_texture(top: Color, bottom: Color) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.set_color(0, top)
	gradient.set_color(1, bottom)
	var tex := GradientTexture2D.new()
	tex.gradient = gradient
	tex.width = 16
	tex.height = 256
	tex.fill = GradientTexture2D.FILL_LINEAR
	tex.fill_from = Vector2(0.5, 0.0)
	tex.fill_to = Vector2(0.5, 1.0)
	return tex


func _radial_texture(color: Color) -> GradientTexture2D:
	var gradient := Gradient.new()
	gradient.set_color(0, Color(color.r, color.g, color.b, 1.0))
	gradient.set_color(1, Color(color.r, color.g, color.b, 0.0))
	var tex := GradientTexture2D.new()
	tex.gradient = gradient
	tex.width = 256
	tex.height = 256
	tex.fill = GradientTexture2D.FILL_RADIAL
	tex.fill_from = Vector2(0.5, 0.5)
	tex.fill_to = Vector2(1.0, 0.5)
	return tex
