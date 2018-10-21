extends KinematicBody2D

var speed = 40 
var moveDir = Vector2()
export(int) var moveTick = 30
var moveTickMax = moveTick
var motion

var playerDist 
var health = 1

var d
var distance

var heartPre = preload("res://Nodes/pickups/Health.tscn")
var newHeart
var newPosition

func _ready():
	moveDir = direction.random()

#loop for random movement
func movementLoop():
	motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

#function for getting direction to avoid player
func runAway(a):
	a = a.normalized() * -1
	if 1-abs(a.x) < 1-abs(a.y):
		moveDir.x= direction.orientation(a.x)
		moveDir.y = 0
	else:
		moveDir.y = direction.orientation(a.y)
		moveDir.x = 0
	if is_on_wall():
		if moveDir.x == 0:
			moveDir.y=0
			match direction.orientation(a.x):
				1:
					moveDir.x = 1
				-1: 
					moveDir.x = -1
		else:
			moveDir.x = 0
			match direction.orientation(a.y):
				1:
					moveDir.y = 1
				-1: 
					moveDir.y = -1

func _physics_process(delta):
	#getting distance between player and bunny
	playerDist =  get_parent().get_node("Player").position
	d = Vector2(playerDist-position)#.normalized()
	distance = sqrt((d.x*d.x)+(d.y*d.y))
	movementLoop()
	
	#check if player is close, thn run
	if distance <= 125:
		speed = 80
		moveDir = Vector2(0,0)
		moveTick= moveTickMax
		runAway(d)
	#not close, idly wander
	else: 
		speed = 40
		if moveTick > 0:
			moveTick -= 1
		if moveTick == 0 || is_on_wall():
			moveDir = direction.random()
			moveTick = moveTickMax

func _process(delta):
	$AnimatedSprite.play()
	if moveDir == direction.right:
		$AnimatedSprite.animation = "right"
	if moveDir == direction.left:
		$AnimatedSprite.animation = "left"
	if moveDir == direction.up:
		$AnimatedSprite.animation = "up"
	if moveDir == direction.down:
		$AnimatedSprite.animation = "down"

func hit(damage):
	health -= damage
	dieCheck()

#death and drop items
func dieCheck():
	if health == 0:
		self.hide()
		#print(self.name, " has died")
		#set up heart
		newHeart = heartPre.instance()
		newPosition= position
		newHeart.position = newPosition
		get_tree().get_root().add_child(newHeart) 
		#spawn
		#kill bunny process
		self.queue_free()