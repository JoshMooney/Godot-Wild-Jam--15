extends KinematicBody2D

const LEVEL_OBJECT_TYPE = "FallingBrick"
const GRAVITY = 10
var velocity = Vector2()
var is_triggered = false
var FLOOR = Vector2(0, -1)
var is_falling = false

func _ready():
	pass 

func GetType():
	return LEVEL_OBJECT_TYPE
	
func trigger():
	if !is_triggered:
		is_triggered = true
		is_falling = true
	
func _physics_process(delta):
	if is_triggered:
		velocity.y += GRAVITY
		handleCollisions()
		move()
		
func handleCollisions():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var name = get_slide_collision(i).collider.name
			if "Player" in name:
				var player = get_slide_collision(i).collider.get_position().y
				var brick = get_position().y
				if  player > brick:
					get_slide_collision(i).collider.dead()
		
func move():
	velocity = move_and_slide(velocity, FLOOR)

func _on_TriggerArea_body_entered(body):
	if body.name == "Player":
		trigger()
		
func isFalling():
	return is_falling
