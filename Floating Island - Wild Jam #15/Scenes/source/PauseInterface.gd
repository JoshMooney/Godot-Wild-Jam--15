extends Node2D

onready var Label = get_node("CanvasLayer/Label")
var paused = false

func _ready():
	Label.hide()
	pass # Replace with function body.

func _process(delta):
	pollInput()
	
func pollInput():
	if Input.is_action_just_released("ui_focus_prev"):
		togglePause()
		
func togglePause():
	paused = !paused
	get_tree().paused = paused

	if paused:
		Label.show()
	else:
		Label.hide()
		
