extends RayCast

onready var tool_label : Spatial = preload("res://scenes/tools/ToolLabel.tscn").instance()
var _is_mousing_over := false
	

func _input(event: InputEvent) -> void:
	var collided_area = get_collider()

	if collided_area is Tool:
		if not _is_mousing_over:
			_is_mousing_over = true
			tool_label.attatch_label_to(collided_area)

	elif _is_mousing_over:
		_is_mousing_over = false
		tool_label.hide()
