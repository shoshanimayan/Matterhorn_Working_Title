extends Node2D

var player
var chealth	# current health
var mhealth	# max health

var full	# number of FULL hearts to render
var half	# flag: should we render half of a heart?
var empty	# number of EMPTY hearts to render

var fulltex = preload("res://Assets/Art/UI Sprites/Heart_Full_UI.png")
var halftex = preload("res://Assets/Art/UI Sprites/Heart_Half_UI.png")
var emptytex = preload("res://Assets/Art/UI Sprites/Heart_empty_UI.png")

var hearts = []		# an array of sprites

func _ready():
	player = get_node("../../..")
	hearts.append($Heart1)
	hearts.append($Heart2)
	hearts.append($Heart3)
	mhealth = player.maxHealth

func _process(delta):
	chealth = player.currentHealth
	
	# could be optimized better: i.e. only update when the player takes dmg or restores health
	if chealth >= 0:
		full = floor(chealth/2)
		half = abs(chealth % 2)		# 1 if odd or 0 if even
		empty = mhealth/2 - (full + half)
		
		for i in range(full):
			hearts[i].set_texture(fulltex)
		if half == 1:
			hearts[ceil(chealth/2)].set_texture(halftex)
		if empty <= mhealth/2:
			for i in range(empty):
				hearts[(mhealth/2)-1 - i].set_texture(emptytex)
