extends CharacterBody3D #DO NOT CHANGE ANYTHING OR THE CODE MIGHT BREAK

var speed = 5.0
var jump_vel = 20.0
var gravity = 90.0

@export var camera:Camera3D

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _physics_process(delta: float) -> void:
	handle_aim()
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_vel
	
	var input_dir := Input.get_vector("left", "right", "up", "down")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)
	
	move_and_slide()

func handle_aim(): # FOR ROTATING THE RAY CAST TOWARDS THE MOUSE POINTER
	var mouse_pos = get_viewport().get_mouse_position()
	var from = camera.project_ray_origin(mouse_pos)
	var cam_dir = camera.project_ray_normal(mouse_pos)
	
	var plane := Plane(Vector3.UP , global_position.y)
	var hit = plane.intersects_ray(from , cam_dir)
	var to_mouse : Vector3 = hit - global_position
	to_mouse.y = 0.0
	if to_mouse.length() < 0.001:
		return
	
	$shooting_ray.rotation = Vector3(0.0 , atan2(-to_mouse.x, -to_mouse.z),0.0)
