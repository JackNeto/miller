extends Particles

export var rows = 20 setget set_rows, get_rows
export var spacing = 1.0 setget set_spacing, get_spacing
onready var camera = get_node("../Camera")
onready var point_camera = get_node("../Camera/PointCamera")
var direction


func update_aabb():
  var size = rows * spacing
  visibility_aabb = AABB(Vector3(-0.5 * size, 0.0, -0.5 * size), Vector3(size, 20.0, size))
  

func set_rows(new_rows):
  rows = new_rows
  amount = rows * rows
  update_aabb()
  if process_material:
    process_material.set_shader_param("rows", rows)

  
func get_rows():
  return rows


func set_spacing(new_spacing):
  spacing = new_spacing
  update_aabb()
  if process_material:
    process_material.set_shader_param("spacing", spacing)


func get_spacing():
  return spacing


func _ready():
  # now that our material has been constructed, re-issue these
  set_rows(rows)


func _process(delta):
  # Center our particles on our cameras position
  var viewport = get_viewport()
  var camera = viewport.get_camera()
  var point_camera = camera.get_child(0)
  # Calculate the direction the camera is pointing at
  var direction = (point_camera.global_transform.origin - camera.global_transform.origin).normalized()
  # Push the position halfway forward in the camera's direction (where the player is looking at)
  var size = rows * spacing * 0.5
  var pos = camera.global_transform.origin + Vector3(direction.x, 0,  direction.z)  * size
  pos.y = 0.0
  global_transform.origin = pos

