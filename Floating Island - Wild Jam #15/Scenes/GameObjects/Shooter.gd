extends StaticBody2D

export var direction = Vector2(1, 0)
export var shoot_rest_steps = 5
export var shoot_begin_delay = 0
var shoot_counter = 0

func _ready():
	pass 
	
func _physics_process(delta):
	if canShoot():
		shoot()

func canShoot():
	shoot_counter += 1
	if shoot_counter >= shoot_rest_steps:
		shoot_counter = 0
		return true 
	return false

func shoot():
	pass

