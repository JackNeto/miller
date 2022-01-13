extends Area

class_name Item

export var item_name : String
export var collect_automatically : bool = false
onready var outline_material = preload("res://assets/shaders/outline_material.tres")
onready var mesh_instance: MeshInstance = $MeshInstance
onready var label_container = $LabelContainer
onready var label = $LabelContainer/Viewport/Label
var is_selected = false


func _ready() -> void:
	ItemDatabase.connect("collect_item", self, "_on_collect_item")
	
	
func collect_item() -> void:
	Game.player.inventory.add_item(item_name, 1)
	queue_free()


func _on_collect_item() -> void:
	if is_selected:
		collect_item()


func _on_body_entered(body: Node) -> void:
	if body == Game.player:
		if collect_automatically:
			collect_item()
		else:
			ItemDatabase.emit_signal("item_selected")
			show_label()
			mesh_instance.set_surface_material(0, outline_material)
			is_selected = true


func _on_body_exited(_body: Node) -> void:
	ItemDatabase.emit_signal("item_unselected")
	hide_label()
	mesh_instance.set_surface_material(0, null)
	is_selected = false


func show_label() -> void:
	label_container.visible = true
	label.text = item_name
	

func hide_label() -> void:
	label_container.visible = false

