extends Area2D

var tripped = false

func _ready():
	$AnimatedSprite.hide()
	pass

func trigger(body):
	if !tripped:
		tripped = true
		body.set_respawn_point(get_position())
		$AnimatedSprite.show()
		$AnimatedSprite.play("Lighting")

func _on_Checkpoint_body_shape_entered(body_id, body, body_shape, area_shape):
	var name = body.name
	if name == "Player":
		trigger(body)


func _on_AnimatedSprite_animation_finished():
	$AnimatedSprite.play("Lit")
