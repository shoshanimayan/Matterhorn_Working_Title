extends Node2D

var player
var ammoAmount

var graphic
var counterLabel

var noAmmoTex = preload("res://Assets/Art/UI Sprites/Empty_Book_UI.png")
var fullAmmoTex = preload("res://Assets/Art/UI Sprites/Book_UI.png")

func _ready():
	player = get_node("../../..")
	counterLabel = $"Ammo text"
	graphic = $"Book sprite"
	
func _process(delta):
	ammoAmount = player.ammo
	counterLabel.text = str(ammoAmount)

	if ammoAmount == 0:
		graphic.set_texture(noAmmoTex)
	else:
		graphic.set_texture(fullAmmoTex)
