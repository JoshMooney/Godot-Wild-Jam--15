extends KinematicBody2D

const SPEED = 250
const MAX_DISTANCE = 1000
const GAME_OBJECT_TYPE = "Dart"

var direction = Vector2(0, 0)
var velocity = Vector2()
var is_shot = false

func _ready():
	pass

func shoot():
	is_shot = true

func _physics_process(delta):
	if is_shot:
		velocity = Vector2(direction.x * SPEED, direction.y * SPEED)
		move()
	handleCollisions()
			
func handleCollisions():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var name = get_slide_collision(i).collider.name
			if !("Player" in name):
				destroy()
			else:
				get_slide_collision(i).collider.dead()
				destroy()
	
func checkDespawn():
	if is_outside_view_bounds():
		queue_free()
	
func is_outside_view_bounds():
	return position.x > OS.get_screen_size().x or position.x < 0.0 \
		or position.y > OS.get_screen_size().y or position.y < 0.0	

func move():
	move_and_slide(velocity)
	
func destroy():
	velocity = Vector2(0, 0)
	queue_free()
	
func SetDirection(dir):
	direction = dir
	
func GetType():
	return GAME_OBJECT_TYPE
	
