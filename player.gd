extends CharacterBody2D

signal exploded
signal hurt
signal died


@onready var anim = $AnimatedSprite2D
@onready var cyote = $cyote
@onready var wscooldown = $wscooldown
@onready var hud = $hud
@onready var smokeparticles = $smokeparticles
@onready var stompbox = $stompbox/CollisionShape2D
@onready var exploparticles = $exploparticles
@onready var explodehbox = $explodebox/CollisionShape2D
@onready var explodetimer = $explodeattacktimer
@onready var gameoverpart = $gameoverparticles

const jumpv = -300
const left = -1
const right = 1

const wsgrav = 300
const wjkick = 600
const wjhight = -500
const hitstunv = 400
const stompv = -300

var speed = gb.movementspeed
var boosts = gb.boosts
var explostr = gb.explostr
var canjump = true
var bored = false
var lastdirection = right
var wallsliding = false
var cantws = false
var flying = false
var hitstun = false
var grav = gb.gravity
var death = false
# Called when the node enters the scene tree for the first time.
func _ready():
	stompbox.disabled = true
	explodehbox.disabled = true


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not hitstun and not death:
		run()
		jump()
		explode()
		wallslide()
		animations()
		stomphbox()
	gravity(delta)
	smoke()
	
	
	move_and_slide()






func run():
	var direction = getdirection()
	if direction != null:
		if velocity.x > speed or velocity.x < -speed:
			carrymomentom()
		else:
			velocity.x = move_toward(velocity.x,speed * direction, 100)
	else:
		velocity.x = move_toward(velocity.x, 0, 100)
	
func carrymomentom():
	if getdirection() == left:
		if velocity.x < 0:
			velocity.x = move_toward(velocity.x, 0, 30)
		elif velocity.x > 0:
			velocity.x = move_toward(velocity.x, 0, 200)
	elif getdirection() == right:
		if velocity.x < 0:
			velocity.x = move_toward(velocity.x, 0, 200)
		elif velocity.x > 0:
			velocity.x = move_toward(velocity.x, 0, 30)



func getdirection():
	if Input.is_action_pressed('ui_left'):
		lastdirection = left
		return left
		
	elif Input.is_action_pressed('ui_right'):
		lastdirection = right
		return right
		
	else:
		return null


func jump():
	if is_on_floor():
		canjump = true
		flying = false
		boosts = gb.boosts
	elif canjump and cyote.is_stopped():
		cyote.start()
	
	
	if Input.is_action_pressed("ui_accept"):
		if wallsliding:
			velocity.y = wjhight
			velocity.x = wjkick * -lastdirection
			cantws = true
			wscooldown.start()
		elif canjump:
			velocity.y = jumpv




func animations():
	if not bored:
		if flying:
			anim.play('combust')
			anim.flip_h = getflip()
		elif wallsliding:
			anim.play('wallslide')
			anim.flip_h = getflip()
		elif velocity.y != 0:
			if velocity.y > 0:
				anim.play('jump down')
				anim.flip_h = getflip()
			else:
				anim.play("jump up")
				anim.flip_h = getflip()
		elif velocity.x != 0:
			anim.play("run")
			anim.flip_h = getflip()
		else:
			anim.play("idle")
			anim.flip_h = getflip()



func getflip():
	var flip = getdirection()
	if flip == left:
		return true
	elif flip == right:
		return false
	else:
		if lastdirection == left:
			return true
		elif lastdirection == right:
			return false

func wallslide():
	if is_on_wall_only() and not cantws and getdirection() != null:
		wallsliding = true
		canjump = true
		boosts = gb.boosts
		flying = false
	else:
		wallsliding = false



func explode():
	if Input.is_action_just_pressed('click') and boosts > 0:
		boosts -= 1
		var angle = get_global_mouse_position()
		var diffrence = Vector2(global_position - angle)
		if gb.uncontrol:
			var fuse = hud.fuseget()
			var shift = 100 - fuse
			diffrence.x += randf_range(shift,-shift)
			diffrence.y += randf_range(shift,-shift)
		var abv = abs(diffrence)
		var add = abv.x + abv.y
		var ratio = explostr/add
		
		velocity.x = ratio * diffrence.x
		velocity.y = ratio * diffrence.y
		flying = true
		exploparticles.emitting = true
		explodeattack()
		exploded.emit()


func gravity(delta):
	if not is_on_floor():
		if not wallsliding:
			velocity.y += grav * delta
		else:
			velocity.y += wsgrav * delta


func _on_cyote_timeout():
	canjump = false


func _on_wscooldown_timeout():
	cantws = false

func hit(v):
	hurt.emit()
	if v > 0:
		velocity.x = hitstunv
	else:
		velocity.x = -hitstunv
	velocity.y = 0
	hitstun = true
	anim.play('hit')
	await anim.animation_finished
	hitstun = false



func smoke():
	var fuse = hud.fuseget()
	if fuse <= 50:
		smokeparticles.emitting = true
	else:
		smokeparticles.emitting = false

func stomphbox():
	if not bored and not hitstun and not wallsliding and velocity.y != 0:
		stompbox.disabled = false
	else:
		stompbox.disabled = true

func _on_stompbox_area_shape_entered(area_rid, area, area_shape_index, local_shape_index):
	if area.is_in_group('enemy'):
		var parent = area.get_parent()
		parent.hit()



func _on_stompbox_body_entered(body):
	if body.is_in_group('enemy'):
		velocity.y = stompv
		body.hit()



func explodeattack():
	explodehbox.disabled = false
	explodetimer.start()
	await explodetimer.timeout
	explodehbox.disabled = true


func _on_explodebox_body_entered(body):
	if body.is_in_group('enemy'):
		body.hit()


func _on_hud_boom():
	hit(randf_range(1,-1))


func _on_hud_died():
	if not death:
		death = true
		anim.play('hit')
		await anim.animation_finished
		died.emit()
		self.hide()


func _on_hud_gameover():
	if not death:
		death = true
		anim.play("hit")
		await anim.animation_finished
		anim.hide()
		gameoverpart.emitting = true
		await gameoverpart.finished
		get_tree().change_scene_to_file()
