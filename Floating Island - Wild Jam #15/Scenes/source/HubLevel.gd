extends Node2D

onready var SceneTransition = get_node("CanvasLayer/SceneTransition")
onready var Level1Portal = get_node("Portals/Level1Portal")
onready var Level2Portal = get_node("Portals/Level2Portal")
onready var ObjectiveArrow = get_node("Player/ObjectiveArrow")
onready var Gem = get_node("Gem")
var current_objective
var current_level

var LEVEL1_COMPLETE = false
var LEVEL2_COMPLETE = false
var LEVEL3_COMPLETE = true

func _ready():
	setCamera()
	
	SceneTransition.set_next_scene("NAN")
	SceneTransition.trigger()
	
	Level1Portal.set_next_stage("res://Scenes/source/Level1.tscn")
	Level2Portal.set_next_stage("res://Scenes/source/Level2.tscn")
	
	current_level = Level1Portal
	current_objective = current_level.get_position()
	ObjectiveArrow.set_objective(current_objective)
	set_level_rewards()
	
	
func setCamera():
	var map_limits = $LevelTileMap.get_used_rect()
	var map_cellsize = $LevelTileMap.cell_size
	$Player/Camera2D.limit_left = (map_limits.position.x * map_cellsize.x + map_cellsize.x)
	$Player/Camera2D.limit_right = map_limits.end.x * map_cellsize.x
	$Player/Camera2D.limit_top = (map_limits.position.y * map_cellsize.y) - map_cellsize.x
	$Player/Camera2D.limit_bottom = map_limits.end.y * map_cellsize.y

func update_objective_arrow(pos):
	ObjectiveArrow.set_objective(pos)

func set_level_rewards():
	if LEVEL1_COMPLETE:
		$LevelRewards/Level1Reward.show()
		$Portals/Level1Portal.deactivate()
	else:
		$Portals/Level1Portal.show()
		$LevelRewards/Level1Reward.hide()
		
	if LEVEL2_COMPLETE:
		$LevelRewards/Level2Reward.show()
		$Portals/Level2Portal.deactivate()
	else:
		$Portals/Level2Portal.show()
		$LevelRewards/Level2Reward.hide()
		
	if LEVEL3_COMPLETE:
		$LevelRewards/Level3Reward.show()
		$Portals/Level3Portal.deactivate()
	else:
		$Portals/Level3Portal.show()
		$LevelRewards/Level3Reward.hide()
		
func _physics_process(delta):
	pollInput()
	update_objective_arrow(current_level.get_position())
	
func pollInput():
	pass
