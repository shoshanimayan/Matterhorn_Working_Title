extends KinematicBody2D
var timer2 = 0
var velocity= Vector2()
const speed = 4
var timer = 30
var ranged_damage = 1

var tex1 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_1.png")
var tex2 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_2.png")
var tex3 = preload("res://Assets/Art/Raccoon/Attack/Projectiles/Paper_3.png")


func _ready():
	# randomize sprite
	var t = randi() % 3
	match t:
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
	var motion = velocity.normalized() * speed
	var col = move_and_collide( motion)
	if col:
		col = col.get_collider()
		if col!=null && !col.has_method("rangedAttack"):
			if col.has_method("hit"):
				col.hit(ranged_damage)
				self.queue_free()
			else:
				self.queue_free()
#		else:
#			$CollisionShape2D.disabled = true
#			timer2 = 10


func _process(delta):
	if timer != 0:
		timer-=1
	if timer == 0:
		velocity = direction.center
	if timer2!=0:
		timer2 -=1 
	if timer2 ==0:
		if $CollisionShape2D.disabled == true:
			$CollisionShape2D.disabled = false


func _physics_process(delta):
	move()
	if velocity == direction.center:
		self.queue_free()


func set_v(v,p):
	match v:
		"left":
			velocity = direction.left
			p.x = p.x - 15
#			print(p)
			position = p
		"right":
			velocity = direction.right
			p.x = p.x + 15
#			print(p)
			position = p
		"up":
			velocity = direction.up
			p.y = p.y-15 
#			print(p)
			position = p
		"down":
			velocity = direction.down
			p.y = p.y+15
#			print("down")
			position = p
#	print(position)
