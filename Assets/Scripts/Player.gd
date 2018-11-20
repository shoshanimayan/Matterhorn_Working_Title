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

var meleeTimer = 0
var moveTimer = 0
var shootTimer = 0
export (int) var meleeTimerMax = 20
export (int) var moveTimerMax = 5
export (int) var shootTimerMax = 30
var can_move = true

### Used in main movement logic
var dir = Vector2()
# used with applying knockback
var col
var collided_with
var d
var v

### Used in attack() [melee attack]
var other
var Ray_Mid
var Ray_Left
var Ray_Right
var Ray_Left_Mid
var Ray_Right_Mid

### Used in ranged_attack()
var projectilePre = preload("res://Nodes/projectile_player.tscn")
var newProjectile
var newPosition

### Temporary win condition
export (int) var winAmt = 30
var game

func _ready():
	show()
	Ray_Mid = get_node("RayCast2D")
	Ray_Left = get_node("RayCast2D2")
	Ray_Right = get_node("RayCast2D3")
	Ray_Left_Mid = get_node("RayCast2D4")
	Ray_Right_Mid = get_node("RayCast2D5")
	game = get_tree()

#########################


func _process(delta):
	if meleeTimer != 0:
		meleeTimer -= 1
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
			#	moveTimer = moveTimerMax
				shootTimer = shootTimerMax
		
		# MELEE ATTACK
		if Input.is_action_just_pressed("ui_accept") and meleeTimer == 0:
			$AnimatedClawSprite.set_frame(0)
			match $AnimatedSprite.animation:
				"left":
					Ray_Mid.cast_to.x = -meleeAttackRange
					Ray_Mid.cast_to.y = 0
					Ray_Left.cast_to.x = -65
					Ray_Left.cast_to.y = 15
					Ray_Right.cast_to.x = -65
					Ray_Right.cast_to.y = -15
					Ray_Left_Mid.cast_to.x = -67
					Ray_Left_Mid.cast_to.x = 7
					Ray_Right_Mid.cast_to.x = -67
					Ray_Right_Mid.cast_to.x = -7
					$AnimatedClawSprite.offset = Vector2(-meleeAttackRange + clawAnimOffset, 0)
					$AnimatedClawSprite.animation = "left_claw"
				"right":
					Ray_Mid.cast_to.x = meleeAttackRange
					Ray_Mid.cast_to.y = 0
					Ray_Left.cast_to.x = 65
					Ray_Left.cast_to.y = 15
					Ray_Right.cast_to.x = 65
					Ray_Right.cast_to.y = -15
					Ray_Left_Mid.cast_to.x = 67
					Ray_Left_Mid.cast_to.x = 7
					Ray_Right_Mid.cast_to.x = 67
					Ray_Right_Mid.cast_to.x = -7
					$AnimatedClawSprite.offset = Vector2(meleeAttackRange - clawAnimOffset, 0)
					$AnimatedClawSprite.animation = "right_claw"
				"up":
					Ray_Mid.cast_to.x = 0
					Ray_Mid.cast_to.y = -meleeAttackRange-10
					Ray_Left.cast_to.x = -15
					Ray_Left.cast_to.y = -65
					Ray_Right.cast_to.x = 15
					Ray_Right.cast_to.y = -65
					Ray_Left_Mid.cast_to.x = 7
					Ray_Left_Mid.cast_to.x = -67
					Ray_Right_Mid.cast_to.x = -7
					Ray_Right_Mid.cast_to.x = -67
					$AnimatedClawSprite.offset = Vector2(0, -meleeAttackRange + clawAnimOffset)
					$AnimatedClawSprite.animation = "up_claw"
				"down":
					Ray_Mid.cast_to.x = 0
					Ray_Mid.cast_to.y = meleeAttackRange
					Ray_Left.cast_to.x = -15
					Ray_Left.cast_to.y = 65
					Ray_Right.cast_to.x = 15
					Ray_Right.cast_to.y = 65
					Ray_Left_Mid.cast_to.x = 7
					Ray_Left_Mid.cast_to.x = 67
					Ray_Right_Mid.cast_to.x = -7
					Ray_Right_Mid.cast_to.x = 67
					$AnimatedClawSprite.offset = Vector2(0, meleeAttackRange - clawAnimOffset)
					$AnimatedClawSprite.animation = "down_claw"
			speed /= 3
			attack()
			$AnimatedClawSprite.show()
			$AnimatedClawSprite.play()	# auto-hides, implemented in the claw animation's script
			meleeTimer = meleeTimerMax
	
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
		collided_with = col.get_collider()
		# check for collision with an enemy
		if collided_with.get_class() == "KinematicBody2D" and !collided_with.has_method("set_v"):
			#print(collided_with.name)
			d = Vector2(collided_with.position-position).normalized() * -1
			v  = Vector2()
			if 1-abs(d.x) < 1-abs(d.y):
				v.x = direction.orientation(d.x)
				v.y = 0
			else:
				v.y = direction.orientation(d.y)
				v.x = 0
			move(v.normalized()*30)
			get_hurt(collided_with.get_damage())

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
	if Ray_Mid.is_colliding():
		other = Ray_Mid.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)
	if Ray_Left.is_colliding():
		other = Ray_Left.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)
	if Ray_Right.is_colliding():
		other = Ray_Right.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)
	if Ray_Right_Mid.is_colliding():
		other = Ray_Right_Mid.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)
	if Ray_Left_Mid.is_colliding():
		other = Ray_Left_Mid.get_collider()
		if other != null and other.has_method("hit"):
			other.hit(meleeDamage)

func check_death():
	if currentHealth <= 0:
		$CollisionShape2D.disabled = true
		can_move = false
		moveTimer = -1
		shootTimer = -1
		# Play animation here, enable fade-in death screen?
		game.change_scene("res://Nodes/GameOverScreen.tscn")
		hide()
		print("u lose :(")

func get_hurt(damage):
	#print(damage)
	currentHealth -= damage
	check_death()

func check_win():
	# TODO: supply official win condition
	# for now: trash >= winAmt
	if trash >= winAmt:
		print("u win!!")
		game.change_scene("res://Nodes/WinScreen.tscn")
	return

func get_trash(amt):
	trash += amt
	check_win()

func push(v,s):
	move(v.normalized()*s)
