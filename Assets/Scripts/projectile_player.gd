extends KinematicBody2D

var timer
var timer2
var velocity= Vector2()
const speed = 7
var ranged_damage = 1

var motion
var col
var data

var tex1 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_1.png")
var tex2 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_2.png")
var tex3 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_3.png")


func _ready():
	#add_collision_exception_with
	# randomize sprite
	timer = $Timer
	timer2 = $Timer2
	match randi() % 3:
		0:
			$Sprite.set_texture(tex1)
		1:
			$Sprite.set_texture(tex2)
		2:
			$Sprite.set_texture(tex3)
		_:	# just to be safe.......
			$Sprite.set_texture(tex1)

func set_damage(damageValue):
	"""Sets the bullet's damage value from the value provided by the player"""
	ranged_damage = damageValue

func move():
	motion = velocity.normalized() * speed
	col = move_and_collide( motion)
	if col:
		data = col.get_collider()
		if data != null && !data.has_method("rangedAttack"):
			if data.has_method("hit"):
				data.hit(ranged_damage)
			self.queue_free()
		else:
			add_collision_exception_with(col)
#			$CollisionShape2D.disabled = true
#			timer2 = 10

func _process(delta):
	if timer.is_stopped():
		velocity = direction.center
	if timer2.is_stopped():
		if $CollisionShape2D.disabled == true:
			$CollisionShape2D.disabled = false


func _physics_process(delta):
	move()
	if velocity == direction.center:
		self.queue_free()

func set_v(v,p):
	match v:
		"walk_left":
			velocity = direction.left
			p.x = p.x - 37
#			print(p)
			position = p
		"walk_right":
			velocity = direction.right
			p.x = p.x + 37
#			print(p)
			position = p
		"walk_up":
			velocity = direction.up
			p.y = p.y-37
#			print(p)
			position = p
		"walk_down":
			velocity = direction.down
			p.y = p.y+37
#			print("down")
			position = p
#	print(position)
