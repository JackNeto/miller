extends Spatial


func attatch_label_to(object: Tool):
	$Viewport/Label.text = object.tool_name
	object.add_child(self)
	self.visible = true
	
func hide():
	self.visible = false
