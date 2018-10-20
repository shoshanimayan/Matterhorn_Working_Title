extends Node

const center = Vector2(0,0)
const left = Vector2(-1,0)
const right = Vector2(1,0)
const up = Vector2(0,-1)
const down = Vector2(0,1)

func orientation(i):
	if i > 0:
		return 1
	if i < 0:
		return -1


func random():
	"""choose random direction"""
	var d = randi() % 4
	match d:
		0:
			return left
		1:
			return right
		2:
			return up
		3: 
			return down