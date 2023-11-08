extends HurtboxBehavior

signal switch_hit;

func on_get_hit(hitbox: HitboxBehavior, attack) -> bool:
	print("Switch hurtbox")
	if(is_immune_hits):
		return false;
	if(attack["can_trigger_switches"]):
		switch_hit.emit();
		return true;
	
	return false;
