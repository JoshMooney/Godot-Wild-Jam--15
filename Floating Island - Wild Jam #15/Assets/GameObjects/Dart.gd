extends KinematicBody2D

const SPEED = 250
const MAX_DISTANCE = 1000

var direction = Vector2(0, 0)
var velocity = Vector2()


func _ready():
	pass

func _physics_process(delta):
	velocity = Vector2(direction.x * SPEED, direction.y * SPEED)
	move()
	
func move():
	move_and_slide(velocity)
	
func destroy():
	velocity = Vector2(0, 0)
	
func SetDirection(dir):
	direction = dir
	
