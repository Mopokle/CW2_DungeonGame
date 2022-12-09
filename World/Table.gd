extends Area2D

var Interactable = false
const DIALOG = preload("res://UI/DialogBox.tscn")
onready var label = $Label


func _on_Table_body_entered(body):
	if body.name == "Player":
		label.visible = true
		Interactable = true


func _on_Table_body_exited(body):
	if body.name == "Player":
		label.visible = false
		Interactable = false

func _input(event):
	if Input.is_key_pressed(KEY_E) and Interactable == true:
		label.visible = false
		var dialog = DIALOG.instance()
		get_parent().add_child(dialog)
