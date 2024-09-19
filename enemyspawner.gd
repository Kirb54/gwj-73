extends Area2D

@export var enemytype : int
@onready var respawntimer = $respawntimer
var enemytracked = null
var track = false
var enemies = [preload("res://shootingenemy.tscn"),preload("res://chargingenemy.tscn"),preload("res://flyingenemy.tscn")]
func _ready():
	spawnenemy()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	trackenemy()



func spawnenemy():
	var inst = enemies[enemytype].instantiate()
	inst.global_position = self.global_position
	enemytracked = inst
	add_sibling.call_deferred(inst)
	track = true


func trackenemy():
	if track:
		if str(enemytracked) == '<Freed Object>':
			track = false
			respawn()
			


func respawn():
	respawntimer.start()
	await respawntimer.timeout
	spawnenemy()
