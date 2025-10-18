extends Node3D
@onready var player: CharacterBody3D = $".."
@onready var camera_3d: Camera3D = $Camera3D

var mouse_sensitivity := 0.0015
var bob_dt := 0.0
var headbob_count := 0
var can_step := false

@export var head_bobbing_enabled := true
@export var bob_freq := 2.0
@export var bob_amp := 0.08

var is_headbobbing := false: set = _set_is_headbobbing


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _physics_process(delta: float) -> void:
	_headbob_logic(delta)
	_handle_zoom(delta)

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouse_sensitivity
		rotation.x = clamp(rotation.x, deg_to_rad(-90.0), deg_to_rad(30.0))

		player.rotation.y -= event.relative.x * mouse_sensitivity

func _headbob_logic(delta: float) -> void:
	if not head_bobbing_enabled:
		return

	if player.velocity.length() > 0.5 and player.is_on_floor():
		bob_dt += delta * player.velocity.length()
		var target_position := _calculate_headbob_motion()
		camera_3d.transform.origin = camera_3d.transform.origin.lerp(target_position, delta * 20)
	else:
		_reset_headbob(delta)

func _calculate_headbob_motion() -> Vector3:
	var pos := Vector3.ZERO
	pos.y += sin(bob_dt * bob_freq) * bob_amp
	
	if headbob_count == 1:
		pos.x += cos(bob_dt * bob_freq / 2) * bob_amp * 2
	elif headbob_count == 0:
		pos.x -= cos(bob_dt * bob_freq / 2) * bob_amp * 2
	
	_check_for_footstep(pos.y)
	return pos

func _reset_headbob(delta: float) -> void:
	if camera_3d.transform.origin == Vector3.ZERO:
		return
	
	camera_3d.transform.origin = camera_3d.transform.origin.lerp(Vector3.ZERO, delta * 10)
	is_headbobbing = false
	bob_dt = 0.0

func _check_for_footstep(pos_y: float) -> void:
	if pos_y < 0 and can_step:
		# emit_signal("stepped")
		can_step = false
	elif pos_y > 0 and not can_step:
		can_step = true

func _handle_zoom(delta: float) -> void:
	var target_fov := 45.0 if Input.is_action_pressed("zoom") else 75.0
	camera_3d.fov = lerpf(camera_3d.fov, target_fov, delta * 5.0)

func _set_is_headbobbing(value: bool) -> void:
	if value == is_headbobbing:
		return
	
	if not value:
		_cycle_headbob_count()
	
	is_headbobbing = value

func _cycle_headbob_count() -> void:
	headbob_count = 1 if headbob_count == 0 else 0
