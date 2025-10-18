extends Node
class_name Anomaly

@export var chance := 1.0

var is_active := false:
	set(value):
		if value:
			on_activate()
		if value == false:
			on_deactivate()
		is_active = value

func on_activate() -> void:
	pass

func on_deactivate() -> void:
	pass
