extends KinematicBody2D
var isdead = false
var hurt_timer = 0 
# class member variables 
var health = 1
var detectionDistance = 200
var playerDist
var timer = 150
var timer2 = 150
var faceDir = Vector2()
var hidden = false
# projectile <- insert later
var isThrowing = false #Is mole firing at player
var isHiding = false #Is mole hiding (reloading)

var heartDrop = preload("res://Nodes/pickups/Health.tscn")
var ammoDrop = preload("res://Nodes/pickups/Ammo.tscn")
var trashSmallDrop = preload("res://Nodes/pickups/Trash_small.tscn")
var projectilePre = preload("res://Nodes/enemies/projectile_enemy.tscn")
var newProjectile
var newPosition
var newItem
var b = true
var dmg = 1
var projectile_dmg = 1

func setup(h, t1, t2, detection, damage, pdmg, boss):
	health = h
	timer = t1
	timer2 = t2
	detectionDistance = detection
	dmg = damage
	projectile_dmg = pdmg
	b = boss

func get_damage():
	return dmg

func _process(delta):
	$AnimatedSprite.play()
	if hurt_timer == 0 :
		if hidden == true:
			$AnimatedSprite.animation = "hidden"
		else:
			$AnimatedSprite.animation = "appear"		
			if faceDir == direction.right:
				$AnimatedSprite.animation = "temp_right"
			if faceDir == direction.left:
				$AnimatedSprite.animation = "temp_left"
	else:
		$AnimatedSprite.animation = "hurt"
		hurt_timer-=1
func _physics_process(delta):
	duck()
	#Checks to see if the enemy is already firing a projectile, in which case do not interrupt (unless death)
	if !isThrowing:
		playerDist =  get_parent().get_node("Player").position
		var d= Vector2(playerDist-position)#.normalized()
		var distance = sqrt((d.x*d.x)+(d.y*d.y))
		getPlayerDir()
		if !hidden:
			if distance < detectionDistance:
				if timer ==0:
					isThrowing = true
					throw()
				else:
					timer -= 1

# Gets which direction the player is from mole to determine which direction for animation to face
func getPlayerDir():
	faceDir = (playerDist-position).normalized()
	if faceDir.x <=0:
		faceDir = direction.left
	else:
		faceDir = direction.right

func duck():
	if timer2 ==0:
		#if $CollisionShape2D.disabled:
		if !hidden:
			hidden = true
			$CollisionShape2D.disabled =  true
			#isThrowing= false
		else:
			hidden = false
			$CollisionShape2D.disabled =  false

			#isthrowing = true 
		timer2 = 150
	else:
		timer2 -=1

func hit(damage):
	#print("hit")
	if !hidden:
		$AnimatedSprite.animation = "hurt"
		health -= damage
		hurt_timer = 15
		dieCheck()

#Begin throwing sequence (both for animation and spawning projectile)
func throw():
	#var throwAngle = get_angle_to(playerDist)
	#start coroutine for throwing
	#print (self.name, throwAngle)
	if !isdead:
		if $AnimatedSprite.animation =="temp_right":
			$AnimatedSprite.animation ="throw_R"
		if $AnimatedSprite.animation =="temp_left":
			$AnimatedSprite.animation ="throw_L"
			
		newProjectile = projectilePre.instance()
		newPosition = position
		newProjectile.set_v(Vector2(playerDist-position),newPosition)
		newProjectile.set_damage(projectile_dmg)
		newProjectile.add_collision_exception_with(self)
		get_tree().get_root().add_child(newProjectile)
		timer = 100
		isThrowing = false;

func dropItems(b):
	if b == true:
		match randi() % 3 + 1:
			2: 
				newItem = heartDrop.instance()
				newItem.position = position
				get_tree().get_root().add_child(newItem)
			1:
				newItem = ammoDrop.instance()
				newItem.position = position
				get_tree().get_root().add_child(newItem)
			3:
				newItem = ammoDrop.instance()
				newItem.position = position
				get_tree().get_root().add_child(newItem)
	else:
		newItem = trashSmallDrop.instance()
		newItem.position = position
		get_tree().get_root().add_child(newItem)
		

func dieCheck():
	if health <= 0:
		$CollisionShape2D.disabled = true
		self.hide()
		isdead=true
		#print(self.name, " has died")
		$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	print("i died")
	dropItems(b)
	self.queue_free()
