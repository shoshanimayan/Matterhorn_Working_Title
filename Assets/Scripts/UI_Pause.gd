extends Panel

var game
var controlsPanel

func _ready():
	self.hide()
	game = get_tree()
	controlsPanel = get_node("../Controls Panel")

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if game.paused == false:
			pause()
		else:
			unpause()

func pause():
	controlsPanel.show()
	game.paused = true
	self.show()
	#print("PAUSED")

func unpause():
	self.hide()
	game.paused = false
	controlsPanel.hide()
	#print("UN-PAUSED")

func _on_Resume_Button_pressed():
	unpause()

func _on_Quit_Button_pressed():
	game.quit()
