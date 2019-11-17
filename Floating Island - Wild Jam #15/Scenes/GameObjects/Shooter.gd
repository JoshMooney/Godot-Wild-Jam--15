extends StaticBody2D

var dart = preload("res://Scenes/GameObjects/Dart.tscn")
export var direction = Vector2(1, 0)
export var timer_start_delay = 0.0
export var cooldown_time = 1.0

func _ready():
	$CoolDownTimer.set("wait_time", cooldown_time)
	$CoolDownTimer.start(timer_start_delay)

func shoot():
	var new_dart = dart.instance()
	new_dart.SetDirection(direction)
	var position = new_dart.get_position()
	position.y += 1.2
	new_dart.set_position(position);
	new_dart.shoot()
	add_child(new_dart)

func _on_CoolDownTimer_timeout():
	shoot()
	$CoolDownTimer.start()
