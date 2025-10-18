extends Area3D

@export var area_forward := false
@export var exit_corridor : StaticBody3D
@export var entrance_corridor : StaticBody3D

signal teleport(isForward)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	body_exited.connect(_on_body_entered)
	#body_entered.connect(_on_body_entered)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass



func _on_body_entered(body: Node3D) -> void:
	if body is CharacterBody3D:
		teleport.emit(area_forward)
		if area_forward:
			var local_pos = exit_corridor.to_local(body.global_position)
			var new_pos = entrance_corridor.to_global(local_pos)
			body.global_position = new_pos
			body.reset_physics_interpolation() # Stops jitter when teleporting
			#print("area_forward")
		else:
			var local_pos = entrance_corridor.to_local(body.global_position)
			var new_pos = exit_corridor.to_global(local_pos)
			body.global_position = new_pos
			body.rotation.y += deg_to_rad(180)
			body.reset_physics_interpolation() # Stops jitter when teleporting
			#print("area_back")
	
		pass
