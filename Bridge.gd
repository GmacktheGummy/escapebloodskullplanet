extends Node3D

var state=0
@export var switchCount=2
var switchesActivated = 0

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if switchesActivated == switchCount:
		state=1
	if state == 0:
		if rotation.z != 90:
			rotation.z = 90
	if state == 1:
		if rotation.z > 0:
			rotation.z -= 1

func _on_bridgeswitch_1_switch_active():
	switchesActivated+=1
	
func _on_bridgeswitch_2_switch_active():
	switchesActivated+=1
