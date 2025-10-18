extends Node
class_name LevelManager

@onready var anomalies: Node = $Anomalies
@onready var progress_number: Label3D = $ProgressNumber

@export var tele_points: Array[Area3D] = []
@export var debug := false

var is_anomaly := false: set = is_anomaly_active
var anomaly_active: Node
var anomaly_array: Array[Node] = []
var anomaly_chances: Array[float] = []
var cur_progress := 0:
	set(value):
		progress_number.text = str(value)
		cur_progress = value

var random = RandomNumberGenerator.new()


func _ready() -> void:
	for child in anomalies.get_children():
		anomaly_array.append(child)
		anomaly_chances.append(child.chance)
	
	for point in tele_points:
		point.teleport.connect(on_loop)


func on_loop(is_forward: bool) -> void:
	on_progress(is_forward)
	deactivate_current_anomaly()
	
	if randi() % 100 < (50 + (cur_progress * 2)):  # 50% chance and increases with each success
		is_anomaly = true
	else:
		is_anomaly = false
	
	if debug:
		print("Is Anomaly: ", is_anomaly)


func on_progress(is_forward: bool) -> void:
	if is_forward:
		match is_anomaly:
			true:
				cur_progress = 0
			false:
				cur_progress += 1
	
	if not is_forward:
		match is_anomaly:
			true:
				cur_progress += 1
			false:
				cur_progress = 0
	
	if debug: print("going_forward: ", is_forward)
	if debug: print("current_progress: ", cur_progress)
	if debug: print("current anomaly chance: ", 50 + (cur_progress * 2))


func deactivate_current_anomaly() -> void:
	if anomaly_active:
		anomaly_active.is_active = false
	
	anomaly_active = null
	is_anomaly = false


func is_anomaly_active(value: bool) -> void:
	if value:
		anomaly_active = anomaly_array[random.rand_weighted(anomaly_chances)]
		anomaly_active.is_active = true
	
	is_anomaly = value
