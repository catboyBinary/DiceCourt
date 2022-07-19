extends Node

export(bool) var enabled = false

export(NodePath) var receiverPath
onready var receiver: KinematicBody = get_node(receiverPath)
onready var pivot: Spatial = receiver.get_node("Pivot")

export(float) var maxSpeed = 10
export(bool) var hasGravity = false
export(float) var maxGravity = 10
export(float) var gravityRate = 2

export(bool) var canJump = false
export(float) var jumpSpeed = 20
export(float) var jumpRate = .2
var isJumping: bool
var verticalVelocity:float

export(float) var mouse_sensitivity = 0.002  # radians/pixel

export(NodePath) var cameraPath
onready var camera: Camera = get_node(cameraPath)

#camera controls
func _unhandled_input(event):
	if enabled:
		if event is InputEventMouseMotion and Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			receiver.rotate_y(-event.relative.x * mouse_sensitivity)
			pivot.rotate_x(-event.relative.y * mouse_sensitivity)
			pivot.rotation.x = clamp(pivot.rotation.x, -1.2, 1.2)
		
		#for browsers
		if Input.is_action_just_released("tdJump"):
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			
		if Input.is_action_just_pressed("zoom"):
			$Tween.interpolate_property(pivot.get_node("Camera"), "fov", 70, 30, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			$Tween.start()
		if Input.is_action_just_released("zoom"):
			$Tween.interpolate_property(pivot.get_node("Camera"), "fov", 30, 70, 0.25, Tween.TRANS_CUBIC, Tween.EASE_OUT)
			$Tween.start()

func bool2float(boolean):
	if boolean:
		return 1.0
	return 0.0

#movement input
func get_movement():
	
	var input_dir = Vector3()
	# desired move in camera direction
	if Input.is_action_pressed("fpsForward"):
		input_dir += -receiver.global_transform.basis.z
	if Input.is_action_pressed("fpsBackward"):
		input_dir += receiver.global_transform.basis.z
	if Input.is_action_pressed("fpsStrafeLeft"):
		input_dir += -receiver.global_transform.basis.x
	if Input.is_action_pressed("fpsStrafeRight"):
		input_dir += receiver.global_transform.basis.x
	input_dir = input_dir.normalized()
	return input_dir

#jumping and gravity
func processVerticalMovement():
	var vv = verticalVelocity
	
	var floorDetector: RayCast = receiver.get_node("FloorDetector")
	
	if floorDetector.is_colliding() and Input.is_action_just_pressed("tdJump"):
		isJumping = true
		
	if isJumping:
		vv = lerp(vv, jumpSpeed, jumpRate)
		if abs(vv - jumpSpeed) < jumpRate:
			isJumping = false 
	
	if vv > -maxGravity && !isJumping:
		vv -= gravityRate
		
	return vv

func move():
	var velocity = Vector3()
	
	var inputs = get_movement()
	verticalVelocity = processVerticalMovement()
	
	var desired_velocity = inputs * maxSpeed
	velocity.x = desired_velocity.x
	velocity.z = desired_velocity.z
	velocity.y = verticalVelocity
	velocity = receiver.move_and_slide(velocity, Vector3.UP, true)

	


	return velocity

func _ready():
	if enabled:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _process(_delta):
	if enabled:
		move()

