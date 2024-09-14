extends CharacterBody2D

signal exploded

@onready var anim = $AnimatedSprite2D
@onready var cyote = $cyote
@onready var wscooldown = $wscooldown

const speed = 500
const jumpv = -300
const left = -1
const right = 1
const grav = 1200
const wsgrav = 300
const wjkick = 400



var boosts = gb.boosts
var explostr = gb.explostr
var canjump = true
var bored = false
var lastdirection = right
var wallsliding = false
var cantws = false
var flying = false



# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	run()
	jump()
	explode()
	wallslide()
	animations()
	gravity(delta)
	
	
	
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
			velocity.y = jumpv
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
		var abv = abs(diffrence)
		var add = abv.x + abv.y
		var ratio = explostr/add
		print(Vector2(ratio * diffrence.x, ratio * diffrence.y))
		velocity.x = ratio * diffrence.x
		velocity.y = ratio * diffrence.y
		flying = true
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
