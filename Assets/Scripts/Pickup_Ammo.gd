extends Area2D

export(int) var ammoRestored = 1

var book1tex = preload("res://Assets/Art/Pickups/Textbook_1.png")
var book2tex = preload("res://Assets/Art/Pickups/Textbook_2.png")
var book3tex = preload("res://Assets/Art/Pickups/Textbook_3.png")

var disabled = false

func _ready():
	# randomize sprite
	var t = randi() % 3
	match t:
		0:
			$Sprite.set_texture(book1tex)
		1:
			$Sprite.set_texture(book2tex)
		2:
			$Sprite.set_texture(book3tex)
		_:
			$Sprite.set_texture(book1tex)

func _on_Ammo_Pickup_body_entered(body):
	if not disabled and body.get_name() == "Player":
		body.ammo += ammoRestored
		#ASP.stream = sfx_collect
		$AudioStreamPlayer.play()
		disabled = true
		self.hide()
