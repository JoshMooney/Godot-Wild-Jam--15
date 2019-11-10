extends Node

func _process(delta):
	updateHud()
	
	
func updateHud():
	$Player/HUD/MarginContainer/VBoxContainer/Dash.text = "Dash: " + str($Player.GetCanDash())
	$Player/HUD/MarginContainer/VBoxContainer/Objects.text = "GameObjects: " + str($Player.GetNumberOfGameObjects())