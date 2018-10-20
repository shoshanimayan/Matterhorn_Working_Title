extends Area2D

export(int) var HealthRestored

var disabled = false

func _on_Health_Pickup_body_entered(body):
	if not disabled and body.get_name() == "Player":
		body.health += 1
		# don't delete; just disable
		disabled = true
		hide()
