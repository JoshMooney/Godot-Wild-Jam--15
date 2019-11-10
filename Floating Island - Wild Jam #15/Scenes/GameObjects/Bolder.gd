extends KinematicBody2D

const POWER = 300
const FLOOR = Vector2(0, -1)
const GRAVITY = 10
const GAME_OBJECT_TYPE = "Bolder"

var is_selected = false
var velocity = Vector2()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _physics_process(delta):	
	velocity.y += GRAVITY
	move()
	
func move():
	velocity = move_and_slide(velocity, FLOOR)

func SetSelected(value):
	is_selected = value
	
	if is_selected:
		print("Bolder Selected")
		$SpriteDefault.hide()
		$SpriteSelected.show()
	else:
		print("Bolder De-Selected")
		$SpriteDefault.show()
		$SpriteSelected.hide()

func interact(direction):
	applyForce(direction, POWER)

func applyForce(direction, force):
	velocity += Vector2(direction.x * force, direction.y * force)
	velocity = move_and_slide(velocity, FLOOR)
	
func GetType():
	return GAME_OBJECT_TYPE
