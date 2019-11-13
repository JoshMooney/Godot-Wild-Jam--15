extends StaticBody2D

const GAME_OBJECT_TYPE = "Sign"

var is_selected = false

func _ready():
	pass

func interact():
	return read()
	
func read():
	print("This sign has nothing posted")
	
func GetType():
	return GAME_OBJECT_TYPE

func SetSelected(value):
	is_selected = value
	
	if is_selected:
		$Sign.hide()
		$SignSelected.show()
	else:
		$Sign.show()
		$SignSelected.hide()