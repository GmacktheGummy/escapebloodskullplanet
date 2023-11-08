extends HitboxBehavior

func _ready():
	super();
	
	Attacks["arrow"] = {
		"id": 0,
		"damage": 1,
		"can_trigger_switches": true
	};
	
	Faction = FACTION_ENUM.PLAYER;

func on_area_entered(hurtbox: HurtboxBehavior) -> void:
	print("Entered an area: ", hurtbox.name)
	if(hurtbox == null || hurtbox.Faction == Faction):
		return;
	if(hurtbox.on_get_hit(self, Attacks["arrow"])):
		pass;	#arrow consumed?
