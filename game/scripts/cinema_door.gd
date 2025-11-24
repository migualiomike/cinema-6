extends StaticBody3D

@export var starting_rotation := 0.0


func ready() -> void:
	self.rotation.y = starting_rotation
