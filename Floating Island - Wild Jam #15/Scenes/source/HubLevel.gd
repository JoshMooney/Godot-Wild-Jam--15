extends Node2D

onready var SceneTransition = get_node("CanvasLayer/SceneTransition")
onready var Level1Portal = get_node("Level1Portal")
onready var ObjectiveArrow = get_node("Player/ObjectiveArrow")
var current_objective


func _ready():
	SceneTransition.set_next_scene("NAN")
	SceneTransition.trigger()
	
	Level1Portal.set_next_stage("res://Scenes/source/Level1.tscn")
	current_objective = Level1Portal.get_position()
	ObjectiveArrow.set_objective(current_objective)

func _physics_process(delta):
	pollInput()
	
func pollInput():
	pass
