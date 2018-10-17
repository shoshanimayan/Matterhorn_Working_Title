extends KinematicBody2D

const speed = 40 
var moveDir
export(int) var moveTick = 1
var moveTickMax = moveTick

func _ready():
	moveDir = direction.random()
	print(moveDir)

func movementLoop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))

func _physics_process(delta):
	movementLoop()
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
