extends Node

var current_language: String = "TH"
var current_mission: int = 1
var score: int = 0
var high_scores: Dictionary = {}
var player_color: Color = Color(0.95, 0.70, 0.26)

const SAVE_PATH := "user://pick_training_scores.json"


func _ready() -> void:
	load_scores()


func load_scores() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		high_scores = {}
		return

	var file := FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file == null:
		high_scores = {}
		return

	var raw_text := file.get_as_text()
	var parsed = JSON.parse_string(raw_text)
	if typeof(parsed) == TYPE_DICTIONARY:
		high_scores = parsed
	else:
		high_scores = {}


func save_scores() -> void:
	var file := FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file == null:
		return

	file.store_string(JSON.stringify(high_scores))


func register_score(mission_id: int, new_score: int) -> bool:
	var key := str(mission_id)
	var current_best := int(high_scores.get(key, 0))

	if new_score > current_best:
		high_scores[key] = new_score
		save_scores()
		return true

	return false


func get_best_score(mission_id: int) -> int:
	return int(high_scores.get(str(mission_id), 0))
