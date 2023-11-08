class_name TriggerObject
extends Node

@export var is_triggered : bool = false;
@export var objects_to_trigger : Array[TriggerableComponent];

func _ready():
	for o in objects_to_trigger:
		o.register_trigger(self);

func on_trigger():
	if(!is_triggered):
		is_triggered = true;
		for o in objects_to_trigger:
			o.on_trigger_activation(self);

func untrigger():
	if(!is_triggered):
		for o in objects_to_trigger:
			o.on_trigger_deactivation(self);
	
	is_triggered = false;
