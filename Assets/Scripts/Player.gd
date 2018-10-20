extends KinematicBody2D
signal hit

export (int) var speed
var health = 6
var ammo = 0

#func _ready():
#	screensize = get_viewport_rect().size

func _process(delta):
	var dir = Vector2()
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	
	if dir.length() > 0:
		$AnimatedSprite.play()
		move_and_slide(dir.normalized()*speed, Vector2(0,0))
		#dir = dir.normalized() * speed
	else:
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()
	
	if dir.x > 0:
		$AnimatedSprite.animation = "right"
	if dir.x < 0:
		$AnimatedSprite.animation = "left"
	# only use the up/down anims if the player goes directly up/down
	if dir.y < 0 && dir.x == 0:
		$AnimatedSprite.animation = "up"
	if dir.y > 0 && dir.x == 0:
		$AnimatedSprite.animation = "down"

func _on_Player_body_entered(body):
	print(body)
