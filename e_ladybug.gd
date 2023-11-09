extends TriggerObject

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 3
@onready var hurtbox : HurtboxBehavior = $Hurtbox;

func _on_hurtbox_switch_hit():
	#Activate the actual Trigger object
	on_trigger();
