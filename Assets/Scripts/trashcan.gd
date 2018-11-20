extends KinematicBody2D
var trashSmallDrop = preload("res://Nodes/pickups/Trash_small.tscn")
var newItem
var newItem2
var newItem3
var newItem4
var newItem5





func hit(x):
	self.hide()
	newItem = trashSmallDrop.instance()
	newItem.position = position
	
	var newItem2 = trashSmallDrop.instance()
	var newItem3 =  trashSmallDrop.instance()
	var newItem4 =  trashSmallDrop.instance()
	var newItem5 =  trashSmallDrop.instance()
	
	get_tree().get_root().add_child(newItem)
	
	newItem2.position = position
	newItem2.position.x = position.x-30
	get_tree().get_root().add_child(newItem2)
	
	newItem3.position = position
	newItem3.position.x = position.x+30
	get_tree().get_root().add_child(newItem3)
	
	newItem4.position = position
	newItem4.position.y = position.y-30
	get_tree().get_root().add_child(newItem4)
	
	newItem5.position = position
	newItem5.position.y = position.y+30
	get_tree().get_root().add_child(newItem5)
	
	#kill mole process
	self.queue_free()

