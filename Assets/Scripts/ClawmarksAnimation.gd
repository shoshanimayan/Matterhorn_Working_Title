extends AnimatedSprite

var player

### DIY ANIMATION ONESHOT ###

func _ready():
	player = get_node("..")
	# hide the sprite immediately
	self.hide()

func _on_AnimatedClawSprite_animation_finished():
	# hide the sprite after an animation plays
	# had to connect the animation_finished() signal to generate this function
	self.hide()
	player.speed *= 3

# only show the sprite while it plays!!!  that's handled in the player script.
