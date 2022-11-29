extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/StartButton.grab_focus()
	
func _on_StartButton_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://World.tscn")


func _on_QuitButton_pressed():
	get_tree().quit()
