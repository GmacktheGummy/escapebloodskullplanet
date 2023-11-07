extends StaticBody3D

signal switchActive

func _on_area_3d_body_entered(body):
	if body.is_in_group("projectile"):
		print("Switch Activated!")
		switchActive.emit()
		queue_free()

