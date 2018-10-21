extends Area2D

export(int) var healthRestored = 2

var disabled = false

func _on_Health_Pickup_body_entered(body):
	if not disabled and body.get_name() == "Player":
		if body.currentHealth < body.maxHealth:
			if body.currentHealth + healthRestored > body.maxHealth:
				body.currentHealth = body.maxHealth
			else:
				body.currentHealth += healthRestored
		
		# don't delete; just disable
		disabled = true
		hide()
