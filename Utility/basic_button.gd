extends Button


signal click_end()


func _on_mouse_entered():
	$hover_snd.play()


func _on_pressed():
	$click_snd.play()


func _on_click_snd_finished():
	emit_signal("click_end")
