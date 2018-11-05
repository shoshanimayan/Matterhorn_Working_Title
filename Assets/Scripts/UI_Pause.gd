extends Panel

# class member variables go here, for example:
# var a = 2
# var b = "textvar"

func _ready():
	self.hide()

func _process(delta):
	if Input.is_action_just_pressed("ui_pause"):
		if get_tree().paused == false:
			pause()
		else:
			unpause()

func pause():
	get_tree().paused = true
	self.show()
	print("PAUSED")

func unpause():
	self.hide()
	get_tree().paused = false
	print("UN-PAUSED")

func _on_Resume_Button_pressed():
	unpause()

func _on_Quit_Button_pressed():
	get_tree().quit()
