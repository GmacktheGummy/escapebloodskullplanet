extends TriggerableComponent

@onready var mesh_container = $MeshContainer;
var active_triggers = 0;

func on_trigger_activation(trigger):
	active_triggers += 1;
	if(active_triggers >= registered_triggers.size()):
		on_activate();

func on_trigger_deactivation(trigger):
	active_triggers -= 1;
	if(active_triggers == registered_triggers.size()):
		on_activate();
		
func on_activate() -> void:
	if mesh_container.rotation.z > 0:
		mesh_container.rotation.z = 0
	
func on_deactivate() -> void:
	if mesh_container.rotat.z != deg_to_rad(90):
		mesh_container.rotation.z = deg_to_rad(90)
