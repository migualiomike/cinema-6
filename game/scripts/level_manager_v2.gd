class_name LevelManager
extends Node

@export var tele_points: Array[Area3D] = []
@export var debug := false

var is_anomaly := false:
	set = is_anomaly_active
var anomaly_active: Node
var anomaly_array: Array[Node] = []
var anomaly_chances: Array[float] = []
var cur_progress := 0:
	set(value):
		if value > 6: cur_progress = 6
		cur_progress = value
		progress_changed.emit()
var random = RandomNumberGenerator.new()
var player_in_hall := false

signal progress_changed()
signal player_hall_changed(is_true:bool)

@onready var hall_detector: Area3D = $HallDetector
@onready var player: CharacterBody3D = $"../CharacterBody3D"
@onready var anomalies: Node = $Anomalies


func _ready() -> void:
	hall_detector.body_entered.connect(player_entered_hall)
	hall_detector.body_exited.connect(player_exited_hall)
	for child in anomalies.get_children():
		anomaly_array.append(child)
		anomaly_chances.append(child.chance)

	for point in tele_points:
		point.teleport.connect(on_loop)

func _physics_process(delta: float) -> void:
	if anomaly_active != null: anomaly_active.process_anomaly(delta)

func player_entered_hall(body:Node3D):
	if body.is_in_group("Player"):
		player_in_hall = true
		player_hall_changed.emit(true)

func player_exited_hall(body:Node3D):
	if body.is_in_group("Player"):
		player_in_hall = false
		player_hall_changed.emit(false)

func on_loop(is_forward: bool) -> void:
	on_progress(is_forward)
	deactivate_current_anomaly()

	if randi() % 100 < (50 + (cur_progress * 2)) and cur_progress != 6: # 50% chance and increases with each success
		is_anomaly = true
	else:
		is_anomaly = false

	if debug:
		print("Is Anomaly: ", is_anomaly)
		if anomaly_active:
			print("current anomaly: ", anomaly_active.name)


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

	if debug:
		print("going_forward: ", is_forward)
	if debug:
		print("current_progress: ", cur_progress)
	if debug:
		print("current anomaly chance: ", 50 + (cur_progress * 2))


func deactivate_current_anomaly() -> void:
	if anomaly_active:
		anomaly_active.is_active = false

	anomaly_active = null
	is_anomaly = false


func is_anomaly_active(value: bool) -> void:
	if value:
		anomaly_active = anomaly_array[random.rand_weighted(anomaly_chances)]
		#anomaly_active = anomaly_array[2]
		anomaly_active.is_active = true

	is_anomaly = value
