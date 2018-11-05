extends Panel

var game

func _ready():
	self.hide()
	game = get_tree()

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if game.paused == false:
			pause()
		else:
			unpause()

func pause():
	game.paused = true
	self.show()
	#print("PAUSED")

func unpause():
	self.hide()
	game.paused = false
	#print("UN-PAUSED")

func _on_Resume_Button_pressed():
	unpause()

func _on_Quit_Button_pressed():
	game.quit()
