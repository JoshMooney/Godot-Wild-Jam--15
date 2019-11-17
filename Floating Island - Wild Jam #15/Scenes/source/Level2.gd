extends Node2D

onready var SceneTransition = get_node("CanvasLayer/SceneTransition")
onready var HubPortal = get_node("Portals/Portal")
onready var ObjectiveArrow = get_node("Player/ObjectiveArrow")
onready var Gem = get_node("Gem")
onready var GemRC = get_node("Gem/RaceCondition")
var current_objective
var level_complete = false
var shake_amount = 1.2
var shakeEnabled = false

var camera_bounds_start = Vector2(-64, 0)
var camera_bounds_end = Vector2(1856, 320)

func _ready():
	setCamera()
	
	SceneTransition.set_next_scene("NAN")
	SceneTransition.trigger()
	HubPortal.set_next_stage("res://Scenes/source/HubLevel.tscn")
	
	current_objective = $Gem.get_position()
	ObjectiveArrow.set_objective(current_objective)
	set_hub_portal()

func setCamera():
	var map_limits = $LevelTileMap.get_used_rect()
	var map_cellsize = $LevelTileMap.cell_size
	$Player/Camera2D.limit_left = (map_limits.position.x * map_cellsize.x + map_cellsize.x)
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = (map_limits.position.y * map_cellsize.y) - map_cellsize.x
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y
	
func set_hub_portal():
	if level_complete:
		HubPortal.activate()
		ObjectiveArrow.set_objective(HubPortal.get_position())
		shakeEnabled = true
	else:
		shakeEnabled = false
		HubPortal.deactivate()

func shake():
    var cam = $Player/Camera2D
    cam.set_offset(Vector2( \
        rand_range(-1.0, 1.0) * shake_amount, \
        rand_range(-1.0, 1.0) * shake_amount \
    ))

func _physics_process(delta):
	if GemRC.started:
		level_complete = true
		set_hub_portal()
	if shakeEnabled:
		shake()
	
func pollInput():
	pass
