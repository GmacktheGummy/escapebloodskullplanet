extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_shoot_arrow():
	var arrowscn = load("res://Prefabs/arrow.tscn")
	# we need to store rotations like this so that the arrow mesh can visually rotate correctly, and
	# so that the literal trajectory of the arrow's velocity is correct
	var arrow_rot = Vector3($Player.rotation)
	var arrow_xrot= $Player/Camera3D.rotation.x
	var arrow_zrot= $Player/Camera3D.rotation.z
	var arrow_pos = Vector3($Player.position.x,$Player.position.y+1.4,$Player.position.z)
	var arrow_str = $Player.bowpull_strength
	var arrow = arrowscn.instantiate()
	arrow.initialize(arrow_rot,arrow_pos,arrow_xrot,arrow_zrot,arrow_str)
	add_child(arrow)
