extends TriggerableComponent

@onready var mesh_container = $StaticBody3D;
@export var target_zrot = deg_to_rad(-10)
@export var start_zrot = deg_to_rad(90)
var bridgestate=0;
var active_triggers = 0;

func _process(delta):
	if (bridgestate==0):
		if (mesh_container.rotation.z != start_zrot):
			mesh_container.rotation.z = start_zrot;
	if (bridgestate==1):
		if (mesh_container.rotation.z < target_zrot) :
			mesh_container.rotation.z += deg_to_rad(1);
		if (mesh_container.rotation.z > target_zrot) :
			mesh_container.rotation.z -= deg_to_rad(1);

func on_trigger_activation(trigger):
	active_triggers += 1;
	if(active_triggers >= registered_triggers.size()):
		bridgestate=1;

func on_trigger_deactivation(trigger):
	active_triggers -= 1;
	if(active_triggers == registered_triggers.size()):
		bridgestate=0;
		
func on_activate() -> void:
	if mesh_container.rotation.z > 0:
		mesh_container.rotation.z = 0
	
func on_deactivate() -> void:
	if mesh_container.rotat.z != deg_to_rad(90):
		mesh_container.rotation.z = deg_to_rad(90)
