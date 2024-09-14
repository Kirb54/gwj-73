extends CharacterBody2D

@export var flipped = false


@onready var bullet = preload("res://bullet.tscn")
@onready var anim = $AnimatedSprite2D
@onready var windup = $windup
@onready var shootimer = $shoottimer
@onready var spawnpos = $spawnpos
@onready var hbox = $CollisionShape2D

const coinval = 3


var attacking = false
var dying = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.flip_h = flipped
	if flipped:
		spawnpos.position.x = 40
	attack()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	idle()


func idle():
	if not attacking and not dying:
		anim.play('idle')


func attack():
	attacking = true
	anim.play("attack")
	windup.start()
	await windup.timeout
	var inst = bullet.instantiate()
	inst.shot(flipped)
	inst.global_position = spawnpos.global_position
	add_sibling(inst)
	attacking = false
	shootimer.start()

func _on_shoottimer_timeout():
	attack()

func hit():
	windup.stop()
	shootimer.stop()
	dying = true
	hbox.disabled = true
	anim.play('hit')
	await anim.animation_finished
	gb.coins += coinval
	self.queue_free()
