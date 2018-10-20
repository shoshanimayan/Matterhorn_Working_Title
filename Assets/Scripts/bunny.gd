extends KinematicBody2D

var speed = 40 
var moveDir = Vector2()
export(int) var moveTick = 30
var moveTickMax = moveTick
var playerDist 


 
func _ready():
	moveDir = direction.random()


func movementLoop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func runAway(a):
	if is_on_ceiling() || is_on_floor():
		moveDir.y = 0
		if moveDir.x == 0:
			match direction.orientation(a.x):
				1:
					moveDir.x = 1
				-1: 
					moveDir.x = -1
			
	if is_on_wall():
		moveDir.x = 0
		if moveDir.y==0:
			match direction.orientation(a.y):
				1:
					moveDir.y = 1
				-1: 
					moveDir.y = -1
	if abs(a.x) > abs(a.y):
		match direction.orientation(a.x):
			1:
				moveDir.x = 1
			-1: 
				moveDir.x = -1
	else:
		match direction.orientation(a.y):
			1:
				moveDir.y = 1
			-1: 
				moveDir.y = -1
	
	
			
		
	

func _physics_process(delta):
	playerDist =  get_parent().get_node("Player").position
	var d= Vector2(position-playerDist)
	var distance = sqrt((d.x*d.x)+(d.y*d.y))
	
	movementLoop()
	if distance <= 100:
		speed = 80
		moveDir = Vector2(0,0)
		moveTick=0
		print(distance)
		runAway(d)
		
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
#	if moveDir == Vector2(1,1) || Vector2(-1,1):
#		$AnimatedSprite.animation = "up"
#	if moveDir == Vector2(1,-1) || Vector2(-1,-1):
#		$AnimatedSprite.animation = "down"
