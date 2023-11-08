extends TriggerObject

@onready var hurtbox : HurtboxBehavior = $Hurtbox;

func _on_hurtbox_switch_hit():
	#Activate the actual Trigger object
	on_trigger();
