extends CharacterBody3D


@export var SPEED = 5.0
const JUMP_VELOCITY = 4.5
var wallrun = false
@export var wallrun_fall = 0

#Mouse variables
var _mouse_input : bool = false
var _mouse_rotation : Vector3
var _rotation_input : float
var _tilt_input : float

@export var tilt_lower_limit := deg_to_rad(-90) #Max lower rotatoin
@export var tilt_upper_limit := deg_to_rad(90) #max upper rotation

func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("menu"):
		get_tree().quit()
		
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

func _unhandled_input(event: InputEvent) -> void:
	_mouse_input = event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED #checks if mouse input event is mouse and its captured
	if _mouse_input: #checks if mouse moving while captured
		_rotation_input = -event.relative.x #X rotation input
		_tilt_input = event.relative.y #y rotation input

func _update_camera(delta):
	_mouse_rotation.x += _tilt_input * delta
	_mouse_rotation.x = clamp(_mouse_rotation.x, tilt_lower_limit, tilt_upper_limit)
	_mouse_rotation.y = _rotation_input * delta
	
	#Tilføj camera movement https://youtu.be/N-jh8qc8tJs?list=PLEHvj4yeNfeF6s-UVs5Zx5TfNYmeCiYwf&t=576
