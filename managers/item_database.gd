extends Node

signal collect_item
signal item_selected
signal item_unselected

var items = Array()
var selected_item: Node

const ITEMS_PATH = "res://scenes/items/"

func _ready() -> void:
	load_item_types()


func load_item_types() -> void:
	var directory  = Directory.new()
	directory.open(ITEMS_PATH)
	directory.list_dir_begin()
	var filename = directory.get_next()
	while(filename):
		if not directory.current_is_dir() and filename != 'item_resource.gd':
			items.append(load("%s%s" % [ITEMS_PATH, filename]))
		filename = directory.get_next()

	
func get_item(item_name) -> ItemResource:
	for i in items:
		if i.name == item_name:
			return i
	return null

