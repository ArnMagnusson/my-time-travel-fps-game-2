extends CharacterBody3D


@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var wallrun = false
@export var wallrun_fall = 0

func _physics_process(delta: float) -> void:
	wall_run(delta)
	# Add the gravity.
	if not is_on_floor():
		if wallrun != true:
			velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("Left", "Right", "Forward", "Backward")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()
	
func wall_run(delta):
	var Rayright = $Rayright
	var Rayleft = $Rayright
	
	if Rayright.is_colliding():
		wallrun = true
		velocity.y = 0
	else:
		wallrun = wallrun_fall
		
	if Rayleft.is_colliding():
		wallrun = true
		velocity.y = wallrun_fall
	else:
		wallrun = false
