extends KinematicBody

export var speed : float = 1
var jog_speed : float = 2.5
var run_speed : float = 3
export var acceleration : float = 5
export var air_acceleration : float = 5
export var gravity : float = 0.98
export var max_terminal_velocity : float = 54
export var jump_power : float = 20

export(float, 0.1, 1) var mouse_sensitivity : float = 0.3
export(float, -90, 0) var min_pitch : float = -30
export(float, 0, 90) var max_pitch : float = 15

var velocity : Vector3
var y_velocity : float

onready var camera_pivot = $CameraPivot
onready var camera = $CameraPivot/CameraBoom/Camera

onready var _animation_tree = $AnimationTree
var jog_blend = "parameters/jog_blend/blend_position"
var carry_blend = "parameters/carry_blend/blend_amount"

var is_carrying : bool = false
onready var right_hand_attachment = $"YBot/game-rig/Skeleton/RightHandToolAttachment/ScythePosition"
onready var raycast = $RayCast
var inventory_resource = load("res://scenes/player/inventory.gd")
var inventory = inventory_resource.new()


func _ready():
	_animation_tree.active = true
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	
func _input(event):
	if event is InputEventMouseMotion:
		rotation_degrees.y -= event.relative.x * mouse_sensitivity
		camera_pivot.rotation_degrees.x -= event.relative.y * mouse_sensitivity
		camera_pivot.rotation_degrees.x = clamp(camera_pivot.rotation_degrees.x, min_pitch, max_pitch)


func _physics_process(delta):
	handle_movement(delta)
	handle_item_pickup(delta)
	
	
func handle_item_pickup(delta) -> void:
	if Input.is_action_just_pressed("ui_select"):
		ItemDatabase.emit_signal("collect_item")
		grab_tool()
		

func handle_movement(delta):
	var direction = Vector3()
	var is_moving = false
	var target = Vector2.ZERO
	
	if Input.is_action_pressed("ui_up"):
		direction -= transform.basis.z
		target.y = 1
		is_moving = true
	if Input.is_action_pressed("ui_down"):
		direction += transform.basis.z
		target.y = -1
		is_moving = true
	if Input.is_action_pressed("ui_left"):
		direction -= transform.basis.x
		target.x = -1
		is_moving = true
	if Input.is_action_pressed("ui_right"):
		direction += transform.basis.x
		target.x = 1
		is_moving = true
		

	direction = direction.normalized()
  
	var accel = acceleration if is_on_floor() else air_acceleration
	velocity = velocity.linear_interpolate(direction * speed, accel * delta)
  
	if is_on_floor():
		y_velocity = -0.01
	else:
		y_velocity = clamp(y_velocity - gravity, -max_terminal_velocity, max_terminal_velocity)
  
#  if Input.is_action_just_pressed("ui_select") and is_on_floor():
#    y_velocity = jump_power
  
	velocity.y = y_velocity
	velocity = move_and_slide(velocity, Vector3.UP, true)
	
	# Set animation

	if is_moving:
		if Input.is_action_pressed("sprint"):
			speed = run_speed
		else:
			speed = jog_speed

	var movement = _animation_tree.get(jog_blend)
	_animation_tree.set(jog_blend, Vector2(lerp(movement.x, target.x, delta *5), lerp(movement.y, target.y, delta *5)))
	
	var carrying_amount = _animation_tree.get(carry_blend)
	if is_carrying && carrying_amount < 1:
		_animation_tree.set(carry_blend, lerp(carrying_amount, 1.0, delta *5))
	if !is_carrying && carrying_amount > 0:
		_animation_tree.set(carry_blend, lerp(carrying_amount, 0, delta *5))
	

func grab_tool() -> void:
	var selected_tool = raycast.get_collider()
	if selected_tool == null:
		return
	selected_tool.translation = Vector3.ZERO
	selected_tool.rotation = Vector3.ZERO
	selected_tool.get_parent().remove_child(selected_tool)
	right_hand_attachment.add_child(selected_tool)
	is_carrying = true
	right_hand_attachment.visible = true	



