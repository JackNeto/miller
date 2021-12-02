extends Spatial

var elapsed = 0

# `pre_start()` is called when a scene is loaded.
# Use this function to receive params from `Game.change_scene(params)`.
func pre_start(params):
  print("\ngameplay.gd:pre_start() called with params = ")
  for key in params:
    var val = params[key]
    printt("", key, val)

  set_process(false)


# `start()` is called when the graphic transition ends.
func start():
  print("\ngameplay.gd:start() called")
  var active_scene: Node = Game.get_active_scene()
  print("\nCurrent active scene is: ",
    active_scene.name, " (", active_scene.filename, ")")
  set_process(true)

