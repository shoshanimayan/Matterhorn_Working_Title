extends Area2D

export (int) var value = 1

var pickup1tex = preload("res://Assets/Art/Pickups/TEMP_ammo.png")
var pickup2tex = preload("res://Assets/Art/Pickups/Screw_1.png")

func _ready():
	# randomize sprite
	var t = randi() % 2
	match t:
		0:
			$Sprite.set_texture(pickup1tex)
		1:
			$Sprite.set_texture(pickup2tex)
		_:
			$Sprite.set_texture(pickup1tex)

func _on_Trash_small_Pickup_body_entered(body):
	if body.get_name() == "Player":
		body.get_trash(value)
		self.queue_free()
