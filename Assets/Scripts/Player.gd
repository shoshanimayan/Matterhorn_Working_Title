extends KinematicBody2D
#signal hit

### Player properties
export (int) var speed = 4
# 2 health = 1 heart, so 3 hearts of health
var maxHealth = 6
export (int) var currentHealth = 6
export (int) var ammo = 0
export (int) var trash = 0

export (int) var meleeDamage = 1
export (int) var rangedDamage = 1
var meleeAttackRange = 50
var clawAnimOffset = 25

var moveTimer = 0
var shootTimer = 0
export (int) var moveTimerMax = 5
export (int) var shootTimerMax = 30
var can_move = true

### Used in main movement logic
var dir = Vector2()
# used with applying knockback
var col
var d
var v

### Used in attack()
var other

### Used in ranged_attack()
var projectilePre = preload("res://Nodes/projectile_player.tscn")
var newProjectile
var newPosition

#########################

func _process(delta):
	if shootTimer != 0:
		shootTimer -= 1
	
	if moveTimer != 0:
		moveTimer -= 1
	
	if can_move:
		# DIRECTIONAL INPUT
		if moveTimer == 0:
			if Input.is_action_pressed("ui_right"):
				dir.x += 1
			if Input.is_action_pressed("ui_left"):
				dir.x -= 1
			if Input.is_action_pressed("ui_up"):
				dir.y -= 1
			if Input.is_action_pressed("ui_down"):
				dir.y += 1
		
		# RANGED ATTACK
		if Input.is_action_just_pressed("ui_select"):
			if shootTimer == 0 and ammo > 0:
				ammo -= 1
				dir = Vector2(0,0)
				rangedAttack($AnimatedSprite.animation)
				moveTimer = moveTimerMax
				shootTimer = shootTimerMax
		
		# MELEE ATTACK
		if Input.is_action_just_pressed("ui_accept"):
			$AnimatedClawSprite.set_frame(0)
			match $AnimatedSprite.animation:
				"left":
					$RayCast2D.cast_to.x = -meleeAttackRange
					$RayCast2D.cast_to.y = 0
					$AnimatedClawSprite.offset = Vector2(-meleeAttackRange + clawAnimOffset, 0)
					$AnimatedClawSprite.animation = "left_claw"
				"right":
					$RayCast2D.cast_to.x = meleeAttackRange
					$RayCast2D.cast_to.y = 0
					$AnimatedClawSprite.offset = Vector2(meleeAttackRange - clawAnimOffset, 0)
					$AnimatedClawSprite.animation = "right_claw"
				"up":
					$RayCast2D.cast_to.x = 0
					$RayCast2D.cast_to.y = -meleeAttackRange
					$AnimatedClawSprite.offset = Vector2(0, -meleeAttackRange + clawAnimOffset)
					$AnimatedClawSprite.animation = "up_claw"
				"down":
					$RayCast2D.cast_to.x =0
					$RayCast2D.cast_to.y = meleeAttackRange
					$AnimatedClawSprite.offset = Vector2(0, meleeAttackRange - clawAnimOffset)
					$AnimatedClawSprite.animation = "down_claw"
			attack()
			$AnimatedClawSprite.show()
			$AnimatedClawSprite.play()	# auto-hides, implemented in the claw animation's script
	
	# setting up player animations (before animations are played)
	if dir.x > 0:
		$AnimatedSprite.animation = "right"
	if dir.x < 0:
		$AnimatedSprite.animation = "left"
	# only use the up/down anims if the player goes directly up/down
	if dir.y < 0 && dir.x == 0:
		$AnimatedSprite.animation = "up"
	if dir.y > 0 && dir.x == 0:
		$AnimatedSprite.animation = "down"
		
	if dir.length() > 0:	# player is walking
		$AnimatedSprite.play()
		move(dir.normalized() * speed)
		dir = Vector2()
	else:		# player is NOT walking
		$AnimatedSprite.set_frame(0)
		$AnimatedSprite.stop()

func move(dir):
	# move_and_collide() returns the object that got collided with
	col = move_and_collide(dir)
	if col:
		col = col.get_collider()
		# check for collision with an enemy
		if col.get_class() == "KinematicBody2D" and !col.has_method("set_v"):
			print (col.name)
			d = Vector2(col.position-position).normalized() * -1
			v  = Vector2()
			if 1-abs(d.x) < 1-abs(d.y):
				v.x = direction.orientation(d.x)
				v.y = 0
			else:
				v.y = direction.orientation(d.y)
				v.x = 0
			can_move = false
			move(v.normalized()*30)
			# REPLACE "1" WITH THE OTHER ENTITY'S DAMAGE - TODO
			get_hurt(1)
			can_move = true

#func _physics_process(delta):
#	if dir.length() > 0:
#		$AnimatedSprite.play()
#		move(dir.normalized() * speed)
#		dir = Vector2()
#	else:
#		$AnimatedSprite.set_frame(0)
#		$AnimatedSprite.stop()

func rangedAttack(dir):
	newProjectile = projectilePre.instance()
	newPosition = position
	newProjectile.set_v($AnimatedSprite.animation,newPosition)
	newProjectile.set_damage(rangedDamage)
	get_tree().get_root().add_child(newProjectile) 

func attack():
	if $RayCast2D.is_colliding():
		other = $RayCast2D.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)

func check_death():
	if currentHealth <= 0:
		print("Player died")
		can_move = false
		moveTimer = -1
		shootTimer = -1
		# Play animation here, enable fade-in death screen?
		hide()
		$CollisionShape2D.disabled = true

func get_hurt(damage):
	#print(damage)
	currentHealth -= damage
	check_death()
