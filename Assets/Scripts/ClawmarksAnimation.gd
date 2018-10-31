extends AnimatedSprite

### DIY ANIMATION ONESHOT ###

func _ready():
	# hide the sprite immediately
	self.hide()

func _on_AnimatedClawSprite_animation_finished():
	# hide the sprite after an animation plays
	# had to connect the animation_finished() signal to generate this function
	self.hide()

# only show the sprite while it plays!!!  that's handled in the player script.
