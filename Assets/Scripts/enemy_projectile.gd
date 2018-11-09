extends KinematicBody2D
var timer2 = 0
var velocity= Vector2()
const speed = 7
var timer = 30
var ranged_damage = 1


func set_damage(damageValue):
	"""Sets the bullet's damage value from the value provided by the player"""
	ranged_damage = damageValue


func move():
	var motion = velocity.normalized() * speed
	var col = move_and_collide( motion)
	var data
	if col:
		data = col.get_collider()
		if data!=null:
			if data.has_method("get_hurt") && !data.has_method("throw"):
				data.get_hurt(1)
				self.queue_free()
			elif data.has_method("throw") ||data.has_method("set_v")  :
				add_collision_exception_with(col)
			else:
				self.queue_free()
		else:
			add_collision_exception_with(col)
#			$CollisionShape2D.disabled = true
#			timer2 = 10


func _process(delta):
	if timer != 0:
		timer-=1
	if timer == 0:
		velocity = direction.center
	if timer2!=0:
		timer2 -=1 
	if timer2 ==0:
		if $CollisionShape2D.disabled == true:
			$CollisionShape2D.disabled = false


func _physics_process(delta):
	move()
	if velocity == direction.center:
		self.queue_free()


func set_v(v,p):
	
	velocity = v#Vector2(cos(v),sin(v)).normalized() 
	position = p
	