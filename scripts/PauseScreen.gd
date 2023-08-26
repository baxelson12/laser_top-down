extends CanvasLayer

func _on_menu_button_pressed():
	get_tree().change_scene_to_file("res://UI/main_menu_screen.tscn")

func _on_quit_button_pressed():
	get_tree().quit()
