extends Anomaly

var posters: Array[Node] = []
var current_poster : Node

func _ready() -> void:
	posters = get_children()

func on_activate() -> void:
	current_poster = posters.pick_random()
	current_poster.texture_albedo = current_poster.ano_poster

func on_deactivate() -> void:
	current_poster.texture_albedo = current_poster.og_poster
	current_poster = null
