extends CharacterBody2D

@onready var anim = $AnimatedSprite2D
@onready var hbox = $hbox/CollisionShape2D
@export var deathsfx = AudioStream
const speed = 300
const coinval = 2

var player = null
var dead = false
# Called when the node enters the scene tree for the first time.
func _ready():
	anim.play("idle")
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if player and not dead:
		followplayer()

	
	
	move_and_slide()




func followplayer():
	var diffrence = Vector2(player.global_position.x-global_position.x,player.global_position.y-global_position.y)
	var mathdif : Vector2
	mathdif = abs(diffrence)
	var findratio = mathdif.x + mathdif.y
	var ratio = speed/findratio
	velocity.x = move_toward(velocity.x, ratio * diffrence.x, 100)
	velocity.y = move_toward(velocity.y, ratio * diffrence.y, 100)
	if velocity.x > 0:
		anim.flip_h = true
	else:
		anim.flip_h = false


func startflying():
	anim.play('activated')
	await anim.animation_finished
	anim.play('fly')


func _on_sight_body_entered(body):
	if body.is_in_group('player'):
		if player == null:
			startflying()
		player = body
		

func hit():
	if not dead:
		dead = true
		hbox.disabled = true
		anim.play('hit')
		sfx.playsound(deathsfx)
		await anim.animation_finished
		gb.coins += coinval + gb.extracoins
		self.queue_free()

func _on_hbox_body_entered(body):
	if body.is_in_group('player') and not dead:
		body.hit(velocity.x)
	
