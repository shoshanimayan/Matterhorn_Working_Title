extends Label

var chealth
var mhealth

var half	# number of HALF hearts to render
var full	# number of FULL hearts to render
var empty	# number of EMPTY hearts to render

func _process(delta):
	var player = get_node("../../../..")
	chealth = player.currentHealth
	mhealth = player.maxHealth
	
	half = chealth % 2
	full = floor(chealth/2)
	empty = mhealth/2 - (full + half)
	
	# boring debug printouts
	var formatString = "Health: %d/%d\n(%d full hearts, %d half hearts, %d black hearts)"
	self.text = formatString % [chealth, mhealth, full, half, empty]
