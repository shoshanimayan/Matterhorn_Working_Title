extends KinematicBody2D

### Player properties
export (int) var speed = 4
var maxHealth = 6			# 2 health = 1 heart, so 3 hearts of health
export (int) var currentHealth = 6
export (int) var ammo = 0
export (int) var trash = 0

export (int) var meleeDamage = 1
export (int) var rangedDamage = 1
var meleeAttackRange = 50

var PlayerAnimator			# animator node
var clawAnimOffset = 25		# how far away from the player sprite to animate the claw sprite

var _MeleeTimer		# used to prevent melee attacks from being spammed
var _ShootTimer		# used to prevent ranged attack spam
var _HurtTimer		# used to stop players from doing anything while they get hurt
var alive = true

### Used in main movement logic
var dir = Vector2()
var facing = Vector2()
var col				# used with applying knockback
var collided_with
var d
var v

### Used in deal_damage() [melee attack]
var other			# the entity that any of our attack rays collided with
var Ray_Mid
var Ray_Left
var Ray_Right
var Ray_Left_Mid
var Ray_Right_Mid

### Used in ranged_attack()
var projectilePre = preload("res://Nodes/projectile_player.tscn")
var newProjectile
var newPosition

### Sound stuff
var AudioPlayer
var sfx_hurt = preload("res://Assets/Sounds/sfx_hurt.wav")
var sfx_melee = preload("res://Assets/Sounds/sfx_melee.wav")
var sfx_throw = preload("res://Assets/Sounds/sfx_throw.wav")

### Temporary win condition
export (int) var winAmt = 30
var game

func _ready():
	PlayerAnimator = $AnimatedSprite
	AudioPlayer = $AudioPlayer
	show()
	Ray_Mid = get_node("RayCast2D")
	Ray_Left = get_node("RayCast2D2")
	Ray_Right = get_node("RayCast2D3")
	Ray_Left_Mid = get_node("RayCast2D4")
	Ray_Right_Mid = get_node("RayCast2D5")
	_MeleeTimer = $MeleeTimer
	_ShootTimer = $ShootTimer
	_HurtTimer = $HurtTimer
	game = get_tree()

#########################

func _process(delta):
	# DIRECTIONAL INPUT
	# bottom right is positive
	if Input.is_action_pressed("ui_right"):
		dir.x += 1
		facing = Vector2(1,0)
	if Input.is_action_pressed("ui_left"):
		dir.x -= 1
		facing = Vector2(-1,0)
	if Input.is_action_pressed("ui_up"):
		dir.y -= 1
		facing = Vector2(0,-1)
	if Input.is_action_pressed("ui_down"):
		dir.y += 1
		facing = Vector2(0,1)
	
	if alive:
		if _HurtTimer.is_stopped():
			# RANGED ATTACK
			if Input.is_action_just_pressed("ui_select") and _ShootTimer.is_stopped():
				rangedAttack()
			
			# MELEE ATTACK
			if Input.is_action_just_pressed("ui_accept") and _MeleeTimer.is_stopped():
				meleeAttack()
			
			set_up_animations("walk")
			if dir.length() > 0:	# player is walking
				PlayerAnimator.play()
				move(dir.normalized() * speed)
				dir = Vector2()
			else:		# player is NOT walking
				PlayerAnimator.set_frame(0)
				PlayerAnimator.stop()
		else:
			# player is getting hurt right now
			set_up_animations("hurt")
			PlayerAnimator.play()

func play_sound(s):
	AudioPlayer.stream = s
	AudioPlayer.play()

func set_up_animations(action):
	"""Uses string concatenation to select a set of animations (DOES NOT PLAY ANIMATIONS)"""
	if facing.x > 0:
		PlayerAnimator.animation = action+"_right"
	if facing.x < 0:
		PlayerAnimator.animation = action+"_left"
	# only use the up/down anims if the player goes directly up/down
	if facing.y < 0 && facing.x == 0:
		PlayerAnimator.animation = action+"_up"
	if facing.y > 0 && facing.x == 0:
		PlayerAnimator.animation = action+"_down"


func move(dir):
	"""Handles the actual movement of the player and manages enemy collision"""
	# move_and_collide() returns the object that got collided with
	col = move_and_collide(dir)
	if col:
		collided_with = col.get_collider()
		# check for collision with an enemy
		if collided_with.get_class() == "KinematicBody2D" and !collided_with.has_method("set_v"):
			#print(collided_with.name)
			d = Vector2(collided_with.position - position).normalized() * -1
			v  = Vector2()
			if 1-abs(d.x) < 1-abs(d.y):
				v.x = direction.orientation(d.x)
				v.y = 0
			else:
				v.y = direction.orientation(d.y)
				v.x = 0
			move(v.normalized()*30)
			get_hurt(collided_with.get_damage())

func rangedAttack():
	if ammo > 0:
		ammo -= 1
		newProjectile = projectilePre.instance()
		newPosition = position
		newProjectile.set_v(PlayerAnimator.animation, newPosition)
		newProjectile.set_damage(rangedDamage)
		get_tree().get_root().add_child(newProjectile)
		play_sound(sfx_throw)
		_ShootTimer.start()

func meleeAttack():
	$AnimatedClawSprite.set_frame(0)
	match PlayerAnimator.animation:
		"walk_left":
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
		"walk_right":
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
		"walk_up":
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
		"walk_down":
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
	deal_damage()
	$AnimatedClawSprite.show()
	$AnimatedClawSprite.play()	# auto-hides, implemented in the claw animation's script
	play_sound(sfx_melee)
	_MeleeTimer.start()

func deal_damage():
	"""Checks each attack ray for collision with something; if that something can be hit, then hit it"""
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
		alive = false
		_ShootTimer.stop()
		# Play animation here, enable fade-in death screen?
		game.change_scene("res://Nodes/GameOverScreen.tscn")
		hide()
		#print("u lose :(")

func get_hurt(damage):
	#print(damage)
	currentHealth -= damage
	check_death()
	play_sound(sfx_hurt)
	_HurtTimer.start()

func check_win():
	# TODO: supply official win condition
	# for now: trash >= winAmt
	if trash >= winAmt:
		#print("u win!!")
		game.change_scene("res://Nodes/WinScreen.tscn")

func get_trash(amt):
	trash += amt
	check_win()

func push(v,s):
	move(v.normalized()*s)
