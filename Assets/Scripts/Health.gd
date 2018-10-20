extends Area2D

export(int) var HealthRestored

var disabled = false

func _on_Health_Pickup_body_entered(body):
	if not disabled:
		print("whoa the health ball was entered", body)
		disabled = true
		hide()
	
