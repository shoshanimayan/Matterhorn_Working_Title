extends Label


func _process(delta):
	# CHANGE player TO THE PATH OF THE Player NODE
	var player = get_node("../../../..")
	var formatString = "Health: %d/%d"
	self.text = formatString % [player.currentHealth, player.maxHealth]
