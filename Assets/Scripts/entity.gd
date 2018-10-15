extends KinematicBody2D

const speed = 0


var moveDir = Vector2()


func movementLoop():
	var motion = moveDir.normalized() * speed
	move_and_slide(motion, Vector2(0,0))
	 

			

		