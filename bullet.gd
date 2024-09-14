extends CharacterBody2D

var speed = 500
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	velocity.x = speed
	
	
	
	move_and_slide()


func shot(f):
	if not f:
		speed *= -1


func _on_area_2d_body_entered(body):
	if body.is_in_group('player'):
		body.hit(speed)
		self.queue_free()
	else:
		self.queue_free()

func hit():
	self.queue_free()
