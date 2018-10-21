extends Node2D

var player
var trashAmount

var graphic
var counterLabel

var noTrashTex = preload("res://Assets/Art/UI Sprites/Trash_Can_Empty_UI.png")
var fullTrashTex = preload("res://Assets/Art/UI Sprites/Trash_Can_Full_UI.png")

func _ready():
	player = get_node("../../..")
	counterLabel = $"Trash text"
	graphic = $"Trash sprite"
	
func _process(delta):
	trashAmount = player.trash
	counterLabel.text = str(trashAmount)

	if trashAmount == 0:
		graphic.set_texture(noTrashTex)
	else:
		graphic.set_texture(fullTrashTex)
