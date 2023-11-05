extends CharacterBody3D

# Minimum speed of the mob in meters per second.
@export var min_speed = 20
# Maximum speed of the mob in meters per second.
@export var max_speed = 24

# This function will be called from the Main scene.
func initialize(arrow_rot,arrow_pos,arrow_xrot,arrow_zrot):
	position=Vector3(arrow_pos)
	rotate_x(arrow_xrot)
	rotate_y(arrow_rot.y)
	rotate_z(arrow_rot.z)
	# We calculate a random speed (integer)
	var random_speed = randi_range(min_speed, max_speed)
	# We calculate a forward velocity that represents the speed.
	velocity = Vector3.FORWARD.rotated(Vector3(1,0,0),arrow_xrot).rotated(Vector3.UP,arrow_rot.y).rotated(Vector3(0,0,1),arrow_zrot) * random_speed
	
func _physics_process(_delta):
	# Iterate through all collisions that occurred this frame
	for index in range(get_slide_collision_count()):
		# We get one of the collisions with the player
		var collision = get_slide_collision(index)
		# If the collision is with anything that isn't worth mentioning
		if collision.get_collider().is_in_group("wall"):
			velocity=Vector3.ZERO
	move_and_collide(velocity * _delta)

#func _on_visible_on_screen_notifier_3d_screen_exited():
	#queue_free()
