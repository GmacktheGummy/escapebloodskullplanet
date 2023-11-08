class_name HitboxBehavior
extends AreaBoxBehavior

@export_group("Offense")
@export var Damage = 0;
@export var Attacks : Dictionary = {};
	
func _init() -> void:
	collision_layer = 0;
	collision_mask = 2;

func _ready() -> void:
	connect("area_entered", on_area_entered)
	
func on_area_entered(hurtbox: HurtboxBehavior) -> void:
	print("Area entered");
	if(hurtbox == null || hurtbox.Faction == Faction):
		return;
	
	var _fwd = Vector2(-owner.facing_direction, 0);
	hurtbox.on_get_hit(self, owner.attack_durations[owner.current_attack_name]);
