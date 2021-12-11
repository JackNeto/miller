extends Label

var _selected_items_count = 0


func _ready() -> void:
	ItemDatabase.connect("item_selected", self, "_on_item_selected")
	ItemDatabase.connect("item_unselected", self, "_on_item_unselected")
	
	
func _on_item_selected() -> void:
	_selected_items_count += 1
	self.visible = true
	self.text = "Press E to pickup"
	
	
func _on_item_unselected() -> void:
	_selected_items_count -= 1
	if _selected_items_count == 0:
		self.visible = false
