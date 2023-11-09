extends CharacterBody3D

@onready var collider = $ColliderShape;

# Minimum speed of the mob in meters per second.
@export var min_speed = 5
# Maximum speed of the mob in meters per second.
@export var max_speed = 40

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var is_stuck = false;
	
# This function will be called from the Main scene.
func initialize(arrow_rot,arrow_pos,arrow_xrot,arrow_zrot,arrow_str):
	position=Vector3(arrow_pos)
	rotate_x(arrow_xrot)
	rotate_y(arrow_rot.y)
	rotate_z(arrow_rot.z)
	# We calculate the strength of the shot
	var random_speed = ((max_speed-min_speed)*(arrow_str*2))
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD.rotated(Vector3(1,0,0),arrow_xrot).rotated(Vector3.UP,arrow_rot.y).rotated(Vector3(0,0,1),arrow_zrot) * random_speed
	
func _physics_process(delta):
	if(!is_stuck):
		velocity.y += (-gravity * delta)/2;
		var has_collided = move_and_collide(velocity * delta);
		if(has_collided):
			collider.disabled = true;
			is_stuck = true;
