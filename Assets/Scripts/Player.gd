extends KinematicBody2D
signal hit

export (int) var speed

#func _ready():
#	screensize = get_viewport_rect().size

func _process(delta):
	var velocity = Vector2()
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	
	if velocity.length() > 0:
		move_and_slide(velocity.normalized()*speed,Vector2(0,0))
		velocity = velocity.normalized() * speed
		$AnimatedSprite.play()
	else:
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
	
	if velocity.x > 0:
		$AnimatedSprite.animation = "right"
	if velocity.x < 0:
		$AnimatedSprite.animation = "left"
	# only use the up/down anims if the player goes directly up/down
	if velocity.y < 0 && velocity.x == 0:
		$AnimatedSprite.animation = "up"
	if velocity.y > 0 && velocity.x == 0:
		$AnimatedSprite.animation = "down"

func _on_Player_body_entered(body):
	print(body)
