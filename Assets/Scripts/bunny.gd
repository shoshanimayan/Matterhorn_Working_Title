extends KinematicBody2D

var speed = 40 
var moveDir = Vector2()
export(int) var moveTick = 30
var moveTickMax = moveTick
var playerDist 
var health = 1


 
func _ready():
	moveDir = direction.random()


#takes 1 damage with hit
func hit():
	health-=1
	dieCheck()

#death and drop items
func dieCheck():
	if health==0:
		self.hide()
		print(self.name, " has died")
		#set up heart
		var heartPre = preload("res://Nodes/pickups/Health.tscn")
		var newHeart = heartPre.instance()
		var newPosition= position
		newHeart.position = newPosition
		get_tree().get_root().add_child(newHeart) 
		#spawn
		#kill bunny process
		self.queue_free()
	
	

#loop for random movement
func movementLoop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

#function for getting direction to avoid player
func runAway(a):
	a=a.normalized()*-1
	if 1-abs(a.x) < 1-abs(a.y):
		moveDir.x= direction.orientation(a.x)
		moveDir.y =0
	else:
		moveDir.y = direction.orientation(a.y)
		moveDir.x =0
	if is_on_wall():
		if moveDir.x==0:
			moveDir.y=0
			match direction.orientation(a.x):
				1:
					moveDir.x = 1
				-1: 
					moveDir.x = -1
		else:
			moveDir.x=0
			match direction.orientation(a.y):
				1:
					moveDir.y = 1
				-1: 
					moveDir.y = -1
					
func _physics_process(delta):
	#getting distance between player and bunny
	playerDist =  get_parent().get_node("Player").position
	var d= Vector2(playerDist-position)#.normalized()
	var distance = sqrt((d.x*d.x)+(d.y*d.y))
	movementLoop()
	
	#if is_on_wall():
	#	hit()
	
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
