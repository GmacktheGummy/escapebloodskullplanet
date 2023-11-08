extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var speed = 6
@export var jump_speed = 14
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

signal shootArrow

var is_grounded = false;
var is_moving = false;
var is_sprinting : bool = false;
@export var max_sprint_speed : float = 12;
var total_velocity_in_frame : Vector3 = Vector3.ZERO;
var last_input : Vector2;
var curr_input : Vector2;
var ground_friction = 20;

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	last_input = Vector2.ZERO;
	curr_input = Vector2.ZERO;

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
				
	if event.is_action_pressed("sprint"):
		#Can only initiate a sprint while grounded
		if(is_grounded):
			is_sprinting = true;
			
	if event.is_action_released("sprint"):
		#If already sprinting while airborne, sprint is only deactivated upon becoming grounded
		if(is_grounded):
			is_sprinting = false;
	
func _physics_process(delta):
	total_velocity_in_frame = Vector3.ZERO;
	
	if(!is_grounded):
		velocity.y += -gravity * delta
		
	last_input = curr_input;
	curr_input = Vector2(Input.get_axis("left", "right"), Input.get_axis("forward", "back"));
	
	var movement_velocity = 0;
	if(is_grounded):
		movement_velocity = GroundedMovement();
	else:
		movement_velocity = AirMovement();
	total_velocity_in_frame += movement_velocity;
	
	if (total_velocity_in_frame != Vector3.ZERO):
		is_moving = true;
	else:
		is_moving = false;
		
	if is_grounded and Input.is_action_just_pressed("jump"):
		total_velocity_in_frame.y = jump_speed
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
	
	velocity += total_velocity_in_frame;
	if(velocity.length() > 0):
		var speed_drop = 0;
		if(is_grounded):
			var speed_bleed = 0;
			if(velocity.length() < GetMaxSpeed()):
				speed_bleed = GetMaxSpeed();
			else:
				speed_bleed = velocity.length();
			speed_drop = ground_friction * speed_bleed * delta;
			
			var new_velocity_multiplier = velocity.length() - speed_drop;
			new_velocity_multiplier /= velocity.length();
			if(new_velocity_multiplier < 0):
				new_velocity_multiplier = 0;
				
			velocity *= new_velocity_multiplier;
		
	move_and_slide()
	if (is_on_floor()):
		is_grounded = true;
	else:
		is_grounded = false;

func GetMaxSpeed() -> float:
	if (!is_sprinting):
		return speed;
	else:
		return max_sprint_speed;

func GroundedMovement() -> Vector3:
	return basis * Vector3(curr_input.x, 0, curr_input.y) * GetMaxSpeed();
	
func AirMovement() -> Vector3:
	var input_dir = (basis * Vector3(curr_input.x, 0, curr_input.y)).normalized();
	var projected_vel = velocity.dot(input_dir);
	var input_velocity = input_dir * GetMaxSpeed();
	var add_speed = input_velocity.length() - projected_vel;
	if(add_speed <= 0):
		return Vector3.ZERO;
		
	var accel_speed = GetMaxSpeed() * input_velocity.length();
	if(accel_speed > add_speed):
		accel_speed = add_speed;
		
	return accel_speed * input_dir;
	
	return basis * Vector3(curr_input.x, 0, curr_input.y) * GetMaxSpeed();
