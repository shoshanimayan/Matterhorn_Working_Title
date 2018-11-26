extends "res://Assets/Scripts/mole.gd"

var nwp2
var np2

var nwp3
var np3

func _ready():
	setup(20, 140, 150, 300)
	
	
	
func throw():
	var p
	#var throwAngle = get_angle_to(playerDist)
	#start coroutine for throwing
	#print (self.name, throwAngle)
	newProjectile = projectilePre.instance()
	newPosition = position
	newProjectile.set_v(Vector2(playerDist-position),newPosition)
	newProjectile.set_damage(1)
	newProjectile.add_collision_exception_with(self)
	get_tree().get_root().add_child(newProjectile) 	
	
	nwp2 = projectilePre.instance()
	
	p = position
	p.x = p.x+30
	np2 = position
	np2.x=np2.x+10
	nwp2.set_v(Vector2(playerDist-p),np2)
	nwp2.set_damage(1)
	nwp2.add_collision_exception_with(self)
	get_tree().get_root().add_child(nwp2) 	
	
	"""nwp3 = projectilePre.instance()
	p = position
	p.x = p.x-30
	np3 = position
	np3.x=np3.x-10
	nwp3.set_v(Vector2(playerDist-p),np3)
	nwp3.set_damage(1)
	nwp3.add_collision_exception_with(self)
	get_tree().get_root().add_child(nwp3) 	"""
	
	timer = 74
	isThrowing = false;
	 
