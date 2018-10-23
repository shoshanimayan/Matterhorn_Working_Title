extends Area2D

export (int) var value = 1

var disabled = false

func _on_Trash_small_Pickup_body_entered(body):
	if not disabled and body.get_name() == "Player":
		body.trash += value
		# don't delete; just disable
		disabled = true
		hide()
