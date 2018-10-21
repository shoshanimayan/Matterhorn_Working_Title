extends KinematicBody2D
#signal hit

var dir = Vector2()
var other
var moving = true
export (int) var speed = 3
export (int) var myMeleeDamage = 1
var maxHealth = 6
export (int) var currentHealth = 1
export (int) var ammo = 0
export (int) var trash = 0

var attackRange = 50

func _process(delta):
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
	if Input.is_action_just_pressed("ui_select"):
		rangedAttack($AnimatedSprite.animation)
	if Input.is_action_just_pressed("ui_accept"):
		match $AnimatedSprite.animation:
			"left":
				$RayCast2D.cast_to.x = -attackRange
				$RayCast2D.cast_to.y = 0
			"right":
				$RayCast2D.cast_to.x = attackRange
				$RayCast2D.cast_to.y = 0
			"up":
				$RayCast2D.cast_to.x = 0
				$RayCast2D.cast_to.y = -attackRange
			"down":	
				$RayCast2D.cast_to.x =0
				$RayCast2D.cast_to.y = attackRange
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

func move(dir):
	var col = move_and_collide(dir)
	if col:
		col = col.get_collider()
		if col.get_class() == "KinematicBody2D":
			var d = Vector2(col.position-position).normalized() * -1
			var v  = Vector2()
			if 1-abs(d.x) < 1-abs(d.y):
				v.x= direction.orientation(d.x)
				v.y = 0
			else:
				v.y = direction.orientation(d.y)
				v.x = 0
			
			
			#if d does not work correctly to push the player back pls look and the bunny run away method
			#just test
			moving = false
			move(v.normalized()*30)
			get_hurt(1)
			moving= true

func _physics_process(delta):
	if dir.length() > 0:
		if moving:
			$AnimatedSprite.play()
			move(dir.normalized()*speed)
		
		#move_and_slide(dir.normalized()*speed, Vector2(0,0))
		dir = Vector2()
	else:
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()

func rangedAttack(dir):
	var projectilePre = preload("res://Nodes/projectile_player.tscn")
	var newProjectile = projectilePre.instance()
	var newPosition= position
	
	#newProjectile.position = newPosition
	newProjectile.set_v($AnimatedSprite.animation,newPosition)
	get_tree().get_root().add_child(newProjectile) 



func attack():
	if $RayCast2D.is_colliding():
		other = $RayCast2D.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(myMeleeDamage)

func check_death():
	
	if currentHealth <= 0:
		print("died")
		hide()
		moving = false
		$CollisionShape2D.disabled=true

func get_hurt(damage):
	print(damage)
	currentHealth -= damage
	check_death()
