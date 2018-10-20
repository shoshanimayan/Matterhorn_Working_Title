extends Label


func _process(delta):
	# CHANGE player TO THE PATH OF THE Player NODE
	var player = get_node("..")
	self.text = "Health: " + str(player.health)
