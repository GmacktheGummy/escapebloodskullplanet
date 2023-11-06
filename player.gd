extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 6
@export var jump_speed = 7
@export var mouse_sensitivity = 0.002
@export var controller_sensitivity=0.002
@export var canShoot = 1
@export var canShoot_timer_length = 60
@export var current_equip = 1
var last_equip = 1
var unequip_timer =0
var unequip_timerval = 30
var canShoot_timer_value = 0
var shootingState = 0
var bowpos_idle_pos = Vector3(0.205, -0.163, -0.27)
var bowpos_idle_zscale = 3
var bowpos_strung_pos = Vector3(0.110, -0.063, -0.20)
var bowpos_strung_zscale = 6
var bowpull_strength = 1
var arrow_zpos_origin = -0.02
var isMoving=false
signal shootArrow

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Capture mouse when the Fire button is pressed
	if event.is_action_pressed("fire") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	# Mouse is in window and inputs can be activated
	if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		#Pause da gaem
		if event.is_action_pressed("pause"):
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		
		#move the camera with the mouse
		if event is InputEventMouseMotion:
			rotate_y(-event.relative.x * mouse_sensitivity)
			$Camera3D.rotate_x(-event.relative.y * mouse_sensitivity)
			$Camera3D.rotation.x = clampf($Camera3D.rotation.x, -deg_to_rad(70), deg_to_rad(70))
		
		# Bow and Arrow
		if current_equip==1:
			if canShoot==1 and shootingState==0:
				if $Camera3D/bow.position.y<bowpos_idle_pos.y:
					$Camera3D/bow.position.y+=.1
			if event.is_action_pressed("fire") and canShoot ==1 and shootingState ==0:
				shootingState=1
			if event.is_action_released("fire") and canShoot ==1 and shootingState ==1:
				bowpull_strength=($Camera3D/bow.scale.z / bowpos_strung_zscale)
				canShoot=0
				shootingState=0
				$Camera3D/bow/arrow.position.z = 0.2
				shootArrow.emit()
	
func _physics_process(delta):
	velocity.y += -gravity * delta
	var input = Input.get_vector("left", "right", "forward", "back")
	var movement_dir = transform.basis * Vector3(input.x, 0, input.y)
	velocity.x = movement_dir.x * speed
	velocity.z = movement_dir.z * speed
	
	if velocity != Vector3.ZERO:
		isMoving=true
	else:
		isMoving=false
	
	move_and_slide()
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		velocity.y = jump_speed
	if current_equip==1:
		#Animation of restringing a new arrow
		if canShoot==0:
			if (canShoot_timer_value<canShoot_timer_length):
				canShoot_timer_value +=1
				if $Camera3D/bow/arrow.position.z>-0.02:
					$Camera3D/bow/arrow.position.z-=0.0035
			else:
				$Camera3D/bow/arrow.position.z = arrow_zpos_origin
				canShoot=1
				canShoot_timer_value=0
		#Animation for Aiming down the bow
		if shootingState==1:
			if $Camera3D/bow.position.x > bowpos_strung_pos.x:
				$Camera3D/bow.position.x-=0.02
			if $Camera3D/bow.position.y < bowpos_strung_pos.y:
				$Camera3D/bow.position.y+=0.02
			if $Camera3D/bow.position.z < bowpos_strung_pos.z:
				$Camera3D/bow.position.z+=0.01
			if $Camera3D/bow.scale.z < bowpos_strung_zscale:
				$Camera3D/bow.scale.z+=0.05
		if shootingState==0:
			$Camera3D/bow.position.x = bowpos_idle_pos.x
			$Camera3D/bow.position.y = bowpos_idle_pos.y
			$Camera3D/bow.position.z = bowpos_idle_pos.z
			$Camera3D/bow.scale.z = bowpos_idle_zscale
	
	
