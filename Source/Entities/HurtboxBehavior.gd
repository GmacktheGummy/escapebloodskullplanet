class_name HurtboxBehavior
extends AreaBoxBehavior

@export var max_health = 1;
@export var curr_health = 1;

var is_immune_damage = false;
var is_immune_hits = false;

#Detects only hitbox layer nodes
func _init() -> void:
	collision_layer = 2;
	collision_mask = 0;

func _ready() -> void:
	connect("area_entered", on_area_entered)

func on_area_entered(hitbox: HitboxBehavior) -> void:
	print("Area entered hurtbox");
	if(hitbox == null || hitbox.Faction == Faction):
		return;

func hurt(amount : int) -> void:
	curr_health = max(curr_health-amount, 0);

func heal(amount : int) -> void:
	curr_health = min(curr_health+amount, max_health);

func on_get_hit(hitbox: HitboxBehavior, attack) -> bool:
	print("Base hurtbox")
	if(is_immune_hits):
		return false;
	if(attack["launch_direction"] == "same"):
		pass;
		print("On get hit");
		if(owner.has_method("launch")):
			print("On launch ", attack["launch_angle"], " - ", hitbox.owner.right.rotated(attack["launch_angle"]));
			owner.launch(hitbox.owner.rotated(deg_to_rad(attack["launch_angle"])) * attack["launch_force"]);
			
	
	return true;

func on_death():
	pass;
