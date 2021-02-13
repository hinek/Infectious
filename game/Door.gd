extends Area2D


const MAX_LEVEL = 4


func _on_Door_body_entered(body):
	if body.name == "Player":
		var regex = RegEx.new()
		regex.compile("\\d+")
		var result = regex.search(get_tree().current_scene.filename)
		var next_level = int(result.get_string()) + 1
		if next_level > MAX_LEVEL:
			get_tree().change_scene("res://Success.tscn")
		else:
			get_tree().change_scene("res://levels/Level%02d.tscn" % next_level)


