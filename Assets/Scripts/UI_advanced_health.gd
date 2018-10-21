extends Node2D

var chealth
var mhealth

var full	# number of FULL hearts to render
var half	# flag: should i render half of a heart?
var empty	# number of EMPTY hearts to render

var fulltex = preload("res://Assets/Art/UI Sprites/Heart_Full_UI.png")
var halftex = preload("res://Assets/Art/UI Sprites/Heart_Half_UI.png")
var emptytex = preload("res://Assets/Art/UI Sprites/Heart_empty_UI.png")

var hearts = []

func _ready():
	hearts.append($Heart1)
	hearts.append($Heart2)
	hearts.append($Heart3)

func _process(delta):
	var player = get_node("../../..")
	chealth = player.currentHealth
	mhealth = player.maxHealth

	full = floor(chealth/2)
	half = chealth % 2
	empty = mhealth/2 - (full + half)
	
	for i in range(full):
		hearts[i].set_texture(fulltex)
	if half == 1:
		hearts[ceil(chealth/2)].set_texture(halftex)
