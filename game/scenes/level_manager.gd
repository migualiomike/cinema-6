extends Node
@onready var progress_number: Label3D = $ProgressNumber

var progress := 0:
	set(value):
		if value <= 0:
			progress = 0
		else: progress = value
		progress_number.text = str(progress)
var percentChanceOfAnomaly := 45
var isAnomaly := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func reset():
	isAnomaly = false
	for child in get_node("Posters").get_children():
		child.texture_albedo = child.og_poster

func on_forward():
	if isAnomaly:
		progress = 0
	else:
		progress += 1
	
	reset()
	# Determine if anomaly
	var chanceOfAnomaly := randi() % 101
	if percentChanceOfAnomaly >= chanceOfAnomaly:
		# Pick Anomaly (just poster for now)
		isAnomaly = true
		var posters := get_node("Posters").get_children()
		var poster := posters[randi() % posters.size()]
		poster.texture_albedo = poster.ano_poster
		
	
func on_backward():
	if !isAnomaly:
		progress = 0
	elif isAnomaly:
		progress += 1
	
	reset()
	progress -=1

func on_teleport(isForward: Variant):
	if isForward:
		on_forward()
	else:
		on_backward()

func _on_area_3d_2_teleport(isForward: Variant) -> void:
	on_teleport(isForward)


func _on_area_3d_teleport(isForward: Variant) -> void:
	on_teleport(isForward)
