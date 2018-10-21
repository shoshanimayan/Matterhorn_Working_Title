extends KinematicBody2D

var velocity= Vector2()
const speed = 3.5
var timer = 40

func _ready():
	pass
	# Called when the node is added to the scene for the first time.
	# Initialization here
#func _on_Player_body_entered(body):
#	if body != null and body.has_method("hit"):
#			body.hit()
#	self.queue_free()
func move():
	var motion = velocity.normalized() * speed
	#move_and_slide(motion, Vector2(0,0))
	var col = move_and_collide( motion)
	if col:
		col = col.get_collider()
		if col!=null && !col.has_method("rangedAttack"):
			if col.has_method("hit"):
				col.hit(1)
				self.queue_free()
			else:
				self.queue_free()
	#	else:
	#		$CollisionShape2D.disabled = true
		
	

func _process(delta):
	if timer != 0:
		timer-=1
	if timer == 0:
		velocity = direction.center
	

	

func _physics_process(delta):
	move()
	if velocity == direction.center:
		self.queue_free()

func set_v(v,p):
	
	match v:
		"left":
			velocity = direction.left
			p.x = p.x - 15
			print(p)
			position = p
		"right":
			velocity = direction.right
			p.x = p.x + 15
			print(p)
			position = p
		"up":
			velocity = direction.up
			p.y = p.y-15 
			print(p)
			position = p
		"down":
			velocity = direction.down
			p.y = p.y+15
			print("down")
			position = p
	print(position)
	
