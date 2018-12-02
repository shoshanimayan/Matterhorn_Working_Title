extends Area2D

export(int) var healthRestored = 2

func _on_Health_Pickup_body_entered(body):
	if body.get_name() == "Player":
		if body.currentHealth < body.maxHealth:
			if body.currentHealth + healthRestored > body.maxHealth:
				body.currentHealth = body.maxHealth
			else:
				body.currentHealth += healthRestored
		
		self.queue_free()
