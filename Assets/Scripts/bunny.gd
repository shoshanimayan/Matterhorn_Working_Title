extends KinematicBody2D

var speed = 40 
var moveDir = Vector2()
export(int) var moveTick = 30
var moveTickMax = moveTick
var motion

var playerDist 
export (int) var health = 1
export (int) var damage = 1

var d
var distance

var heartDrop = preload("res://Nodes/pickups/Health.tscn")
var ammoDrop = preload("res://Nodes/pickups/Ammo.tscn")
var trashSmallDrop = preload("res://Nodes/pickups/Trash_small.tscn")

var newItem

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
	# Get distance between player and bunny
	playerDist =  get_parent().get_node("Player").position
	d = Vector2(playerDist-position)#.normalized()
	distance = sqrt((d.x*d.x)+(d.y*d.y))
	movementLoop()
	
	# If player is close, run away
	if distance <= 125:
		speed = 80
		moveDir = Vector2(0,0)
		moveTick= moveTickMax
		runAway(d)
	# Player is not close, idly wander
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

func get_damage():
	return damage

func dropItems():
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
			newItem = heartDrop.instance()
			newItem.position = position
			get_tree().get_root().add_child(newItem)

func dieCheck():
	if health <= 0:
		$CollisionShape2D.disabled = true
		self.hide()
		#print(self.name, " has died")
		$AudioStreamPlayer.play()


func _on_AudioStreamPlayer_finished():
	dropItems()
	self.queue_free()
