extends Node2D

onready var Timer = get_node("Timer")
onready var Gem = $Gem
var started = false
var current_objective

func _ready():
	self.connect("RaceConidition", self, "trigger", [])
	set_current_objective(Vector2(0, 0))
	pass

func reset():
	started = false
	Timer.stop()
	pass
	
func trigger():
	started = true
	Timer.start()
	pass
	
func race_conditions_trigger():
	# Level over
	pass
	
func set_current_objective(obj):
	current_objective = obj

func _on_Timer_timeout():
	pass 
