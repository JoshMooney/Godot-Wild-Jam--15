extends Area2D

export var next_stage = ""
onready var SceneTransitionOut = get_node("CanvasLayer/SceneTransition")

func _ready():
	$AnimatedSprite.play("default")

func set_next_stage(stage):
	next_stage = stage

func trigger():
	SceneTransitionOut.set_next_scene(next_stage)
	SceneTransitionOut.trigger()
	
func _on_Portal_body_shape_entered(body_id, body, body_shape, area_shape):
	var name = body.name
	if name == "Player":
		trigger()
