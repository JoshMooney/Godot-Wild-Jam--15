extends ColorRect

onready var tween = get_node("Tween")
export var SPEED = 1.2
export var TIME = 1.0
export var cutoff_percentage = 0.75
var cutoff_value = 0
var first_run = true
var next_scene = ""
var start = false

export var direction = -1

func _ready():
	hide()
	set_as_toplevel(true)
	set_fade_direction(direction)
	#$HBoxContainer/VBoxContainer/PauseLabel.hide()

func set_next_scene(scene_path):
	next_scene = scene_path

func change_scene():
	if next_scene != "NAN":
		get_tree().change_scene(next_scene)

func _process(delta):
	if next_scene != "" && start:
		if cutoff_value > 0 && cutoff_value < 1 || first_run:
			if first_run:
				first_run = false
			fade(delta)
		else:
			change_scene()

func trigger():
	show()
	start = true

func set_fade_direction(dir):
	var shaderMaterial = self.get_material()
	direction = dir
	if direction > 0:
		cutoff_value = 0
	else:
		cutoff_value = 1
	shaderMaterial.set_shader_param("cutoff", cutoff_value)
	
func fade(delta):
	var shaderMaterial = self.get_material()
	cutoff_value += (SPEED * delta  / TIME) * direction
	shaderMaterial.set_shader_param("cutoff", cutoff_value)
	
