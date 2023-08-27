extends Button

var main_scene = preload("res://scene/World.tscn").instance()

func  _on_StartButton_pressed():
	get_tree().get_root().add_child(main_scene)	
