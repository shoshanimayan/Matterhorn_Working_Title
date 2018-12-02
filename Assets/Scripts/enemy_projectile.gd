extends KinematicBody2D

var timer
var timer2
var velocity= Vector2()
const speed = 7
var ranged_damage = 1

var motion
var col
var data

func _ready():
	timer = $Timer
	timer2 = $Timer2

func set_damage(damageValue):
	ranged_damage = damageValue

func move():
	motion = velocity.normalized() * speed
	col = move_and_collide(motion)
	if col:
		data = col.get_collider()
		if data != null:
			if data.has_method("get_hurt") && !data.has_method("throw"):
				data.get_hurt(ranged_damage)
				self.queue_free()
			elif data.has_method("throw") || data.has_method("set_v"):
				add_collision_exception_with(col)
			else:
				self.queue_free()
		else:
			add_collision_exception_with(col)
#			$CollisionShape2D.disabled = true
#			timer2 = 10

func _process(delta):
	if timer.is_stopped():
		velocity = direction.center
	if timer2.is_stopped():
		if $CollisionShape2D.disabled == true:
			$CollisionShape2D.disabled = false

func _physics_process(delta):
	move()
	if velocity == direction.center:
		self.queue_free()

func set_v(v,p):
	velocity = v#Vector2(cos(v),sin(v)).normalized() 
	position = p
