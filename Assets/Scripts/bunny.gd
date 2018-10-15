extends KinematicBody2D

const speed = 40 
var moveDir
var moveTimer =15

func _ready():
	moveDir = direction.random()
	print(moveDir)

func movementLoop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))
	
func _physics_process(delta):
	"""movementLoop()"""
	if moveTimer >0:
		moveTimer-=1
	if moveTimer==0 || is_on_wall():
		moveDir = direction.random()
		moveTimer = 15
		
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
			
		