extends StaticBody2D

const GAME_OBJECT_TYPE = "Door"
export var lock_type = "Bronze"
var is_selected = false
var is_locked = true

func _ready():
	pass

func interact(keys):
	if lock_type in keys:
		unlock()

func unlock():
	is_locked = false
	$Locked.hide()
	$Selected.hide()
	$Open.show()
	$CollisionShape2D.disabled = true
	
func GetType():
	return GAME_OBJECT_TYPE
	
func SetSelected(value):
	is_selected = value
	
	if is_selected:
		$Locked.hide()
		$Selected.show()
	else:
		$Locked.show()
		$Selected.hide()