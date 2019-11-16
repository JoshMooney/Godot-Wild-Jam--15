extends StaticBody2D

const GAME_OBJECT_TYPE = "Key"
export var key_type = "Bronze"
export var bob_y_range = 250
export var speed = 400
var starting_position
var direction = -1
onready var tween = get_node("Sprite/Tween")
var property = "transform/pos"

func _ready():
	var to = Vector2(60,100)
	var from = Vector2(250,450) 
	
	var pos = get_position()
	pos.y += bob_y_range
	moveToTarget(to, from)
	
func moveToTarget(end, start):
	var distance = start.distance_to(end)
	var time = distance / speed
	#var tween = $Sprite/Tween
	tween.set_active(true)
	
	if tween.is_active():
		tween.stop(self, property)
		tween.interpolate_property(self, property, start, end, time, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.interpolate_property(self, "transform/scale", Vector2(0,0), Vector2(1,1), .8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
		tween.start()

func interact():
	return pickup()

func pickup():
	queue_free()
	return key_type
	
func GetType():
	return GAME_OBJECT_TYPE
