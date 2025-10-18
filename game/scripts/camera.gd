extends Camera3D
@onready var character_body_3d: CharacterBody3D = $".."

var mouseSensitivity := 0.0015

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_pressed("zoom"):
		fov = lerpf(fov, 45.0, 5.0*delta)
	elif !Input.is_action_pressed("zoom"):
		fov = lerpf(fov, 75.0, 5.0*delta)

func _input(event):  		
	if event is InputEventMouseMotion:
		rotation.x -= event.relative.y * mouseSensitivity
		rotation_degrees.x = clamp(rotation_degrees.x, -90.0, 30.0)
		character_body_3d.rotation.y -= event.relative.x * mouseSensitivity
