extends KinematicBody2D
signal hit

var dir = Vector2()
var other

export (int) var speed
var maxHealth = 6
var currentHealth = 4
var ammo = 0
var trash = 0

#func _ready():
#	screensize = get_viewport_rect().size

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_pressed("ui_accept"):
		match $AnimatedSprite.animation:
			"left":
				$RayCast2D.cast_to.x = -50
				$RayCast2D.cast_to.y = 0
			"right":
				$RayCast2D.cast_to.x = 50
				$RayCast2D.cast_to.y = 0
			"up":
				$RayCast2D.cast_to.x = 0
				$RayCast2D.cast_to.y = -50
			"down":	
				$RayCast2D.cast_to.x =0
				$RayCast2D.cast_to.y = 50
		attack()
	
	if dir.x > 0:
		$AnimatedSprite.animation = "right"
	if dir.x < 0:
		$AnimatedSprite.animation = "left"
	# only use the up/down anims if the player goes directly up/down
	if dir.y < 0 && dir.x == 0:
		$AnimatedSprite.animation = "up"
	if dir.y > 0 && dir.x == 0:
		$AnimatedSprite.animation = "down"

func _physics_process(delta):
	if dir.length() > 0:
		$AnimatedSprite.play()
		move_and_collide(dir.normalized()*speed)
		#move_and_slide(dir.normalized()*speed, Vector2(0,0))
		dir = Vector2()
	else:
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()

#func _on_Player_body_entered(body):
#	print(body)

func attack():
	if $RayCast2D.is_colliding():
		other = $RayCast2D.get_collider()
		if other != null and other.has_method("hit"):
			other.hit()
