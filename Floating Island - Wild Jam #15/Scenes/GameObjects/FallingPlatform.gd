extends StaticBody2D

const LEVEL_OBJECT_TYPE = "FallingPlatform"
var is_triggered = false

func _ready():
	pass
	
func trigger():
	if !is_triggered:
		$AnimatedSprite.play("Cracked")
		is_triggered = true
		$TriggerTimer.start()
		print("timer Started")

func _on_TriggerTimer_timeout():
	$AnimatedSprite.play("Smoke")
	$CollisionShape2D.disabled = true
	print("Platform Triggered")

func GetType():
	return LEVEL_OBJECT_TYPE

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Smoke":
		queue_free()

func reset():
	$AnimatedSprite.play("Normal")
	$CollisionShape2D.disabled = false
	is_triggered = false
