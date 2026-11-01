extends CharacterBody3D #DO NOT CHANGE ANYTHING OR THE CODE MIGHT BREAK

var speed = 5.0
var gravity = 90.0

@export var camera:Camera3D

@onready var ray = $shooting_ray


func _input(_event: InputEvent) -> void:
	if Input.is_action_pressed("shoot"):
		print("pressed shoot")
		shoot()


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CONFINED

func _physics_process(delta: float) -> void:
	handle_aim()
	if not is_on_floor():
		velocity.y -= gravity * delta
	
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
	ray.rotation = Vector3(0.0 , atan2(-to_mouse.x, -to_mouse.z),0.0)


func shoot(): #FOR SHOOTING ENEMIES AND RIGIDBODIES
	ray.force_raycast_update()
	if ray.is_colliding():
		var collider = ray.get_collider()
		var collider_point = ray.get_collision_point()
		var dir = (collider_point - ray.global_position).normalized()
		
		if collider.has_method("hit"):
			collider.hit()
		
		if collider is RigidBody3D:
			collider.apply_impulse(dir * 5.0 , collider_point - collider.global_position)
