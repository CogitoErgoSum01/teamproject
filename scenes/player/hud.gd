extends CanvasLayer

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause"):
		$pause_menu.visible = true
		get_tree().paused = true



func _on_resume_pressed() -> void:
	get_tree().paused = false
	$pause_menu.visible = false


func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().reload_current_scene()


func _on_quit_pressed() -> void:
	get_tree().paused = false
	get_tree().quit()
