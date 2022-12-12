
extends CanvasLayer

func _ready():
	$PanelContainer/MarginContainer/Rows/CenterContainer/VBoxContainer/StartButton.grab_focus()


func _on_QuitButton_pressed():
	get_tree().quit()

func _on_Start_pressed():
	get_tree().paused = false
	get_tree().change_scene("res://World.tscn")
	


func _on_start_tab_clicked(tab):
	get_tree().paused = false
	get_tree().change_scene("res://World.tscn")
