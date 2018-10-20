extends KinematicBody2D

# class member variables 
var health = 2
var detectionDistance = 200
var playerDist
var faceDir = Vector2()
# projectile <- insert later
var isThrowing = false #Is mole firing at player
var isHiding = false #Is mole hiding (reloading)


func _ready():
	pass

func _process(delta):
	dieCheck()
	$AnimatedSprite.play()
	if faceDir == direction.right:
		$AnimatedSprite.animation = "temp_right"
	if faceDir == direction.left:
		$AnimatedSprite.animation = "temp_left"

func _physics_process(delta):
	dieCheck()
	
	#Checks to see if the enemy is already firing a projectile, in which case do not interrupt (unless death)
	if !isThrowing:
		playerDist =  get_parent().get_node("Player").position
		var d= Vector2(playerDist-position)#.normalized()
		var distance = sqrt((d.x*d.x)+(d.y*d.y))
		getPlayerDir()
		
		if distance < detectionDistance:
			isThrowing = true
			throw()
	
	


# Gets which direction the player is from mole to determine which direction for animation to face
func getPlayerDir():
	faceDir = (playerDist-position).normalized()
	if faceDir.x <=0:
		faceDir = direction.left
	else:
		faceDir = direction.right



func dieCheck():
	if health==0:
		print(self.name, " has died")
		#set up heart
		var heartPre = preload("res://Nodes/pickups/Health.tscn")
		var newHeart = heartPre.instance()
		var newPosition= position
		newHeart.position = newPosition
		get_tree().get_root().add_child(newHeart) 
		#spawn
		self.hide()
		#kill mole process
		self.queue_free()


func hit():
	health -= 1

#Begin throwing sequence (both for animation and spawning projectile)
func throw():
	var throwAngle = get_angle_to(playerDist)
	#start coroutine for throwing
	print (self.name, throwAngle)
	isThrowing = false;
