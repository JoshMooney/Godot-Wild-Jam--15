extends StaticBody2D

const GAME_OBJECT_TYPE = "Key"
export var key_type = "Bronze"

func _ready():
	pass

func interact():
	return pickup()

func pickup():
	queue_free()
	return key_type
	
func GetType():
	return GAME_OBJECT_TYPE
