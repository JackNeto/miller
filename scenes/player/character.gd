extends Spatial

# IK foot placement
export (Vector2) var min_max_interpolation = Vector2(0.03, 0.0)
export (float) var foot_offset = 0.05
export (float) var ik_raycast_height = 0.5

onready var target_left = $target_container_left
onready var target_right = $target_container_right
onready var raycast_left = $RayCastLeft
onready var raycast_right = $RayCastRight
onready var attach_left = $rig_deform/Skeleton/LeftFoot
onready var attach_right = $rig_deform/Skeleton/RightFoot
onready var ik_left = $rig_deform/Skeleton/SkeletonIKLeftFoot
onready var ik_right = $rig_deform/Skeleton/SkeletonIKRightFoot
onready var default_basis_left = target_left.transform.basis
onready var default_basis_right = target_right.transform.basis

func _ready() -> void:
	ik_right.start()
	ik_left.start()


func look_at_y(from: Vector3, to: Vector3, up_ref: Vector3 = Vector3.UP):
	var forward = (to - from).normalized()
	var right = up_ref.normalized().cross(forward).normalized()
	forward = right.cross(up_ref).normalized()
	return Basis(right, up_ref, forward)


func update_ik_anim(target: Position3D, raycast: RayCast, bone_attach: BoneAttachment, default_basis, raycast_height_offset, hit_offset):
	var bone_pos = bone_attach.global_transform.origin
	raycast.global_transform.origin = bone_pos + Vector3.UP * raycast_height_offset
	target.global_transform.origin = bone_pos
	target.transform.basis = default_basis
	var hit_point = raycast.get_collision_point().y + hit_offset
	
	if raycast.is_colliding():
		target.global_transform.origin = hit_point
		if raycast.get_collision_normal() != Vector3.UP:
			target.global_transform.basis = look_at_y(Vector3.ZERO, get_global_transform().basis.z, raycast.get_collision_normal())
		
	
func _physics_process(_delta) -> void:
	update_ik_anim(target_left, raycast_left, attach_left, default_basis_left, ik_raycast_height, foot_offset)
	update_ik_anim(target_right, raycast_right, attach_right, default_basis_right, ik_raycast_height, foot_offset)
	ik_right.interpolation = clamp($IK_interpolationRight.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
	ik_left.interpolation = clamp($IK_interpolationLeft.transform.origin.y, min_max_interpolation.x, min_max_interpolation.y)
	
