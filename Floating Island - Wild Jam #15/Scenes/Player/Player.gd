extends KinematicBody2D

enum {
	IDLE,
	MOVING,
	JUMPING,
	DASHING,
	WALL_HUGGING,
	DIEING
}

const SPEED = 140
const JUMP_POWER = -250
const GRAVITY = 10
const FLOOR = Vector2(0, -1)
const CAST_LENGTH = 20

var velocity = Vector2()
var is_jumping = false
var on_ground = true
var on_wall = false
var direction = 1
var holding_wall = false
var can_jump = true
var currentState = IDLE

func _ready():
	pass 

func _physics_process(delta):
	pollInput()
	move()

# Responsible for handling the input of the Player
func pollInput():
	on_wall = $RayCast2D.is_colliding()
	
	# Handles the movement of the player 
	if Input.is_action_pressed("ui_right"):
		currentState = MOVING
		direction = 1
		
		if on_wall and not on_ground:
			holding_wall = true
			velocity.y = 0
			can_jump = true
			
		velocity.x = SPEED
		$RayCast2D.set_cast_to(Vector2(CAST_LENGTH, 0))
	elif Input.is_action_pressed("ui_left"):
		currentState = MOVING
		direction = -1
		
		if on_wall and not on_ground:
			holding_wall = true
			velocity.y = 0
			can_jump = true
			
		velocity.x = -SPEED
		$RayCast2D.set_cast_to(Vector2(-CAST_LENGTH, 0))
	else:
		velocity.x = 0
		
	if !on_wall:
		holding_wall = false
		
	if Input.is_action_just_pressed("ui_select") && can_jump && not holding_wall:
		velocity.y = JUMP_POWER
		calulate_jump_velocity()
		
		is_jumping = true
		can_jump = false

func calulate_jump_velocity():
	velocity.y = JUMP_POWER
	
	#if character is not on ground, reduce the speed so he doesn't jump too far away
	var airControlAccelerationLimit = 0.2  # Higher = more responsive air control
	var airSpeedModifier = 0.7 # the 0.7f in your code, affects max air speed
	var targetHorizVelocity = direction * SPEED * airSpeedModifier;  # How fast we are trying to move horizontally
	
	var targetHorizChange = targetHorizVelocity - velocity.x; #How much we want to change the horizontal velocity
	var horizChange = clamp(targetHorizChange ,-airControlAccelerationLimit , airControlAccelerationLimit ) # How much we are limiting ourselves to changing the horizontal velocity
	velocity = Vector2(velocity.x + horizChange, velocity.y)

func move():
	if is_on_floor():
		can_jump = true
		holding_wall = false
	else:
		on_ground = false
		#if velocity.y  < 0:
		#	$AnimatedSprite.play("jump")
		#else:
		#	$AnimatedSprite.play("fall")
	
	# If on the wall and not on the ground dont apply GRAVITY
	if holding_wall:
		velocity.y += GRAVITY*0.35
	else:
		velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)