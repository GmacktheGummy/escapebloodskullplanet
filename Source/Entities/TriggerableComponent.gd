class_name TriggerableComponent
extends Node

var registered_triggers : Array;
var is_triggered : bool;
func register_trigger(trigger):
	registered_triggers.append(trigger);

#Default behavior would be to count how many triggers are active
func on_trigger_activation(trigger):
	pass;

func on_trigger_deactivation(trigger):
	pass;

func on_activate() -> void:
	pass;
	
func on_deactivate() -> void:
	pass;
