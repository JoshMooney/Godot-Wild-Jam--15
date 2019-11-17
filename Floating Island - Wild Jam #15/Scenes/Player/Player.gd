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
var is_dash = false
var can_dash = true
var dash_count = 0
var dash_count_limit = 3
var dash_scaler = 15
var wall_slide_scaler = 0.3
var using_force = false
var is_dead = false

var selected_game_object
var f_game_objects = ["Bolder", "Slate"]
var selectable_game_objects = ["Bolder", "Slate", "Door", "Sign"]
var dangerious_game_objects = ["Spike", "Dart"]
var force_game_objects = []
var keys = []
onready var respawn_point = get_position()

func _ready():
	pass 

func _physics_process(delta):
	if !is_dead:
		pollInput()
		move()
		handleCollisions()
			
func handleCollisions():
	if get_slide_count() > 0:
		for i in range(get_slide_count()):
			var name = get_slide_collision(i).collider.name
			if "Spike" in name:
				dead()
			if "Dart" in name:
				var dart = get_slide_collision(i).collider.get_position().y
				var player = get_position().y
				var frameSize = $AnimatedSprite.get_sprite_frames().get_frame("Falling", 0).get_height()
				var total_height = player + frameSize/2
				if  total_height < dart:
					bounce()
				else:
					dead()
				get_slide_collision(i).collider.destroy()
			if "Key" in name:
				var type = get_slide_collision(i).collider.pickup()
				keys.append(type)
			if "FallingPlatform" in name:
				get_slide_collision(i).collider.trigger()
			if "FallingBrick" in name:
				var brick = get_slide_collision(i).collider.get_position().y
				var player = get_position().y
				if  player > brick:
					dead()
				#if get_slide_collision(i).collider.isFalling():
				#	dead()
				
func dead():
	is_dead = true
	velocity = Vector2(0, velocity.y)
	$AnimatedSprite.play("Die")
	$CollisionShape2D.disabled = true

# Responsible for handling the input of the Player
func pollInput():
	on_wall = $RayCast2D.is_colliding()
	on_ground = is_on_floor()
	
	# Handles the movement of the player 
	if Input.is_action_pressed("ui_right") && !is_dash:
		currentState = MOVING
		direction = 1
		
		if on_wall and not on_ground:
			holding_wall = true
			velocity.y = 0
			can_jump = true
			
		velocity.x = SPEED
		$RayCast2D.set_cast_to(Vector2(CAST_LENGTH, 0))
		if on_ground:
			$AnimatedSprite.play("Running")
		$AnimatedSprite.flip_h = false
	elif Input.is_action_pressed("ui_left") && !is_dash:
		currentState = MOVING
		direction = -1
		
		if on_wall and not on_ground:
			holding_wall = true
			velocity.y = 0
			can_jump = true
			
		velocity.x = -SPEED
		$RayCast2D.set_cast_to(Vector2(-CAST_LENGTH, 0))
		if on_ground:
			$AnimatedSprite.play("Running")
		$AnimatedSprite.flip_h = true
	else:
		velocity.x = 0
		
	if Input.is_action_just_pressed("ui_home") && selected_game_object != null && !using_force:
		useForce(Vector2(-1, 0))
		$AnimatedSprite.play("Force")
		using_force = true
	elif Input.is_action_just_pressed("ui_end") && selected_game_object != null && !using_force:
		useForce(Vector2(1, 0))
		$AnimatedSprite.play("Force")
		using_force = true
	if Input.is_action_just_pressed("ui_accept") && can_dash && !using_force:
		can_dash = false
		is_dash = true
		$DashTimer.start()
		currentState = DASHING
		$AnimatedSprite.play("Dash")
		$AnimatedSprite.frame = 0 
	if Input.is_action_just_pressed("ui_focus_next"):
		cycleNextGameObject()
	
	calulate_dash_velocity()
	findNextGameObject()
	
	if holding_wall && !on_ground:
		$AnimatedSprite.play("Wall Slide")
	if velocity == Vector2(0, 0) && !is_dash && !using_force:
		$AnimatedSprite.play("Idle")
	
	if !on_wall:
		holding_wall = false
		
	if Input.is_action_just_pressed("ui_select") && can_jump && not holding_wall:
		respawn()
		velocity.y = JUMP_POWER
		calulate_jump_velocity()
		is_jumping = true
		can_jump = false
		$AnimatedSprite.play("Jump")
	
	if !on_ground && !on_wall && !is_dash && !using_force:
		if velocity.y < 0:
			$AnimatedSprite.play("Jump")
		else:
			$AnimatedSprite.play("Falling")

func set_respawn_point(pos):
	respawn_point = pos
	
func respawn():
	set_position(respawn_point)
	is_dead = false
	$AnimatedSprite.play("Idle")
	$CollisionShape2D.disabled = false

func findNextGameObject():
	if force_game_objects.size() > 0 && selected_game_object == null:
		selected_game_object = force_game_objects[0]
		selected_game_object.SetSelected(true)

func cycleNextGameObject():
	if force_game_objects.size() >= 2:
		selected_game_object.SetSelected(false)
		#var index = force_game_objects.bsearch(selected_game_object, true)
		var index = force_game_objects.find(selected_game_object, 0)
		if index >= 0:
			index += 1
		else:
			assert("Something weird just happened")
		if index >= force_game_objects.size():
			index = 0
			
		selected_game_object = force_game_objects[index]
		selected_game_object.SetSelected(true)
		
func calulate_jump_velocity():
	velocity.y = JUMP_POWER
	
	#if character is not on ground, reduce the speed so he doesn't jump too far away
	var airControlAccelerationLimit = 0.2  # Higher = more responsive air control
	var airSpeedModifier = 0.7 # the 0.7f in your code, affects max air speed
	var targetHorizVelocity = direction * SPEED * airSpeedModifier;  # How fast we are trying to move horizontally
	
	var targetHorizChange = targetHorizVelocity - velocity.x; #How much we want to change the horizontal velocity
	var horizChange = clamp(targetHorizChange ,-airControlAccelerationLimit , airControlAccelerationLimit ) # How much we are limiting ourselves to changing the horizontal velocity
	velocity = Vector2(velocity.x + horizChange, velocity.y)

func calulate_dash_velocity():
	if is_dash && dash_count < dash_count_limit:
		velocity.x = SPEED * direction * dash_scaler
		dash_count += 1
	elif dash_count >= dash_count_limit:
		is_dash = false
		dash_count = 0

func useForce(forceDirection):
	if selected_game_object != null:
		var objectType = selected_game_object.GetType()
		if objectType in "Bolder":
			selected_game_object.interact(forceDirection)
		elif objectType in "Slate":
			forceDirection = Vector2(forceDirection.y, forceDirection.x)
			selected_game_object.interact(forceDirection)
		elif objectType in "Sign":
			selected_game_object.interact()
		elif objectType in "Door":
			selected_game_object.interact(keys)

func move():
	if is_on_floor():
		can_jump = true
		holding_wall = false
	else:
		on_ground = false
	
	# If on the wall and not on the ground dont apply GRAVITY
	if holding_wall:
		velocity.y += GRAVITY*wall_slide_scaler
	else:
		velocity.y += GRAVITY
	velocity = move_and_slide(velocity, FLOOR)

func GetNumberOfGameObjects():
	return force_game_objects.size()

func GetCanDash():
	return can_dash

func _on_DashTimer_timeout():
	is_dash = false
	can_dash = true
	currentState = IDLE

func _on_GravityBoundingCircle_body_shape_entered(body_id, body, body_shape, area_shape):
	enterBoundingCircle(body_id, body, body_shape, area_shape)

func _on_GravityBoundingCircle_body_shape_exited(body_id, body, body_shape, area_shape):
	exitBoundingCircle(body_id, body, body_shape, area_shape)
	pass

func exitBoundingCircle(body_id, body, body_shape, area_shape):
	var name = ""
	if body != null && body.has_method("GetType"):
		print(body.GetType())
		name = body.GetType()
	#var is_force_object = name.find(selectable_game_objects[0], 0) > -1 || name.find(selectable_game_objects[1], 0) > -1
	var is_force_object = findNameInList(name, selectable_game_objects)
	if is_force_object:
		body.SetSelected(false)
		
		if body == selected_game_object:
			selected_game_object = null
		
		var index = force_game_objects.find(body)
		force_game_objects.remove(index)

func enterBoundingCircle(body_id, body, body_shape, area_shape):
	var name = body.name
	
	#TODO: Change this implementation I am not the biggest fan of it
	#var is_force_object = name.find(selectable_game_objects[0], 0) > -1 || name.find(selectable_game_objects[1], 0) > -1
	var is_force_object = findNameInList(name, selectable_game_objects)
	#if name in selectable_game_objects:
	if is_force_object:
		if selected_game_object == null:
			body.SetSelected(true)
			selected_game_object = body
		force_game_objects.append(body)

func findNameInList(name, list):
	for index in list:
		if name.find(index, 0) > -1:
			return true
	return false

func bounce():
	velocity.y = JUMP_POWER
	calulate_jump_velocity()

func _on_AnimatedSprite_animation_finished():
	if $AnimatedSprite.animation == "Dash":
		print("Dash Ended")
	if $AnimatedSprite.animation == "Die":
		get_tree().change_scene("res://Scenes/Levels/TestWorld.tscn")
	using_force = false

func _on_InteractionBoundingCircle_body_shape_entered(body_id, body, body_shape, area_shape):
	enterBoundingCircle(body_id, body, body_shape, area_shape)

func _on_InteractionBoundingCircle_body_shape_exited(body_id, body, body_shape, area_shape):
	exitBoundingCircle(body_id, body, body_shape, area_shape)


func _on_GravityBoundingCircle_area_entered(area):
	pass # Replace with function body.


func _on_InteractionBoundingCircle_area_entered(area):
	pass # Replace with function body.


func _on_InteractionBoundingCircle_area_exited(area):
	pass # Replace with function body.
