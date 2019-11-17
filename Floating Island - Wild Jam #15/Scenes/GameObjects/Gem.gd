extends StaticBody2D

const GAME_OBJECT_TYPE = "Key"
var key_type
export var bob_y_range = 250
export var speed = 400
var starting_position
var direction = -1

var next_objective
onready var RaceCondition = get_node("RaceCondition")
var property = "transform/pos"

func _ready():
	var to = Vector2(60,100)
	var from = Vector2(250,450) 
	
	var pos = get_position()
	pos.y += bob_y_range
	moveToTarget(to, from)
	set_sprite()
	
func set_gem_type(type):
	key_type = type
	set_sprite()

func set_sprite():
	if key_type == "L1":
		$Level1.show()
		$Level2.hide()
		$Level3.hide()
	if key_type == "L2":
		$Level1.hide()
		$Level2.show()
		$Level3.hide()
	if key_type == "L3":
		$Level1.hide()
		$Level2.hide()
		$Level3.show()
	
func moveToTarget(end, start):
	var distance = start.distance_to(end)
	var time = distance / speed
	#var tween = $Sprite/Tween
	#tween.set_active(true)
	
	#if tween.is_active():
	#	tween.stop(self, property)
	#	tween.interpolate_property(self, property, start, end, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
	#	tween.interpolate_property(self, "transform/scale", Vector2(0,0), Vector2(1,1), .8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	#	tween.start()

func interact():
	return pickup()

func pickup():
	$CollisionShape2D.disabled = true
	$Level1.hide()
	$Level2.hide()
	$Level3.hide()
	RaceCondition.set_current_objective(next_objective)
	RaceCondition.trigger()
	return key_type
	
func GetType():
	return GAME_OBJECT_TYPE
