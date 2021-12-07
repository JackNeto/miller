extends Camera

export var lerp_speed = 3.0
export (NodePath) var target_path = null
export (Vector3) var offset = Vector3.ZERO
var target = null

# Camera shake
onready var noise = OpenSimplexNoise.new()
var noise_y = 0
export var decay = 0.8  # How quickly the shaking stops [0, 1].
export var max_roll = 0.1  # Maximum rotation in radians (use sparingly).
var trauma = 0.0  # Current shake strength.
var trauma_power = 2  # Trauma exponent. Use [2, 3].
var timer 

func _ready():
  randomize()
  noise.seed = randi()
  noise.period = 4
  noise.octaves = 2
  if target_path:
    target = get_node(target_path)


func _physics_process(delta):
  if !target:
    return
  var target_pos = target.global_transform.translated(offset)
  global_transform = global_transform.interpolate_with(target_pos, lerp_speed * delta)
  look_at(target.global_transform.origin, Vector3.UP)
