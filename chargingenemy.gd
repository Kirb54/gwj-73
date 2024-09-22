extends CharacterBody2D

@export var flipped = false
@export var deathsfx = AudioStream

@onready var hboxleft = $hbox/CollisionShape2D
@onready var hboxright = $hbox2/CollisionShape2D
@onready var sight = $RayCast2D
@onready var idletimer = $idletimer
@onready var anim = $AnimatedSprite2D

const speed = 800
const grav = 800
const bonkbounce = -300
const bonkpush = 400
const coinval = 5



var direction = -1
var charging = false


func _ready():
	hboxleft.disabled = true
	hboxright.disabled = true
	if flipped:
		direction = 1
		anim.flip_h = true
		sight.target_position.x = 300


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	findplayer()
	movecharge()
	gravity(delta)
	move_and_slide()



func findplayer():
	if sight.is_colliding():
		charge()

func movecharge():
	if charging:
		velocity.x = speed * direction
	else:
		if is_on_floor():
			velocity.x = move_toward(velocity.x,0,1)

	
	
func charge():
	sight.enabled = false
	charging = true
	anim.play('charge')
	if direction == 1:
		hboxright.disabled = false
	else:
		hboxleft.disabled = false



func gravity(delta):
	velocity.y += grav * delta


func bonked(s):
	hboxright.disabled = true
	hboxleft.disabled = true
	charging = false
	anim.play('hitsomething')
	velocity.x = bonkpush * -direction
	velocity.y = bonkbounce
	await anim.animation_finished
	if s == 'w':
		direction *= -1
		if direction == 1:
			anim.flip_h = true
			sight.target_position.x = 300
		else:
			anim.flip_h = false
			sight.target_position.x = --300
	sight.enabled = true


func _on_hbox_body_entered(body):
	if body.is_in_group('player'):
		body.hit(velocity.x)
		bonked('p')
	elif body.is_in_group('tilemap'):
		bonked('w')
	


func _on_hbox_2_body_entered(body):
	if body.is_in_group('player'):
		body.hit(velocity.x)
		bonked('p')
	elif body.is_in_group('tilemap'):
		bonked('w')

func hit():
	charging = false
	hboxleft.disabled = true
	hboxright.disabled = true
	anim.play("hurt")
	sfx.playsound(deathsfx)
	await anim.animation_finished
	gb.coins += coinval + gb.extracoins
	self.queue_free()
	
