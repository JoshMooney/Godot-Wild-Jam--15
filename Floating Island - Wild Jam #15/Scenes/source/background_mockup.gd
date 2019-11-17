extends Node2D

onready var FadeOutHandler = get_node("CanvasLayer/FadeOutHub")
const ARROW_OFFSET_X = -10
const ARROW_OFFSET_Y = 10
var hubLevelPath = "res://Scenes/source/HubLevel.tscn"
var menuItems = ["Start", "Quit"]
var menuIndex = 0 


func _ready():
	setArrow()
	
func _physics_process(delta):
	pollInput()
	
func pollInput():
	if Input.is_action_just_pressed("ui_up"):
		menuIndex = safeIncrement(-1, menuIndex, menuItems.size())
		setArrow()
	if Input.is_action_just_pressed("ui_down"):
		menuIndex = safeIncrement(1, menuIndex, menuItems.size())
		setArrow()
		
	if Input.is_action_just_pressed("ui_select"):
		action()

func setArrow():
	match menuItems[menuIndex]: 
		"Start":
			var hbox = $HBoxContainer.get_position()
			var label = $HBoxContainer/VBoxContainer/StartLabel.get_position()
			
			var pos = hbox + label
			pos.x += ARROW_OFFSET_X
			pos.y += ARROW_OFFSET_Y
			$Arrow.set_position(pos)
		"Quit":
			var hbox = $HBoxContainer.get_position()
			var label = $HBoxContainer/VBoxContainer/QuitLabel.get_position()
			
			var pos = hbox + label
			pos.x += ARROW_OFFSET_X
			pos.y += ARROW_OFFSET_Y
			$Arrow.set_position(pos)

func safeIncrement(amount, index, size):
	index += amount
	if index == size:
		index = 0
	return index

func action():
	match menuItems[menuIndex]: 
		"Start":
			startGame()
		"Quit":
			get_tree().quit()
			
func startGame():
	$CanvasLayer/FadeOutHub.set_next_scene("res://Scenes/source/HubLevel.tscn")
	$CanvasLayer/FadeOutHub.trigger()