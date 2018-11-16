extends CanvasLayer

var game

func _ready():
	game = get_tree()


func _on_RestartButton_pressed():
	game.change_scene("res://Level1.tscn")


func _on_QuitButton_pressed():
	game.quit()
