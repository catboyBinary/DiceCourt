extends Node

export(bool) var enabled = false
export(NodePath) var receiverPath
onready var receiver: KinematicBody = get_node(receiverPath)

export(float) var maxSpeed = 10
export(bool) var hasGravity = false
export(float) var maxGravity = 20
export(float) var gravityRate = 5

enum hAxis{X, Z}
export(hAxis) var horizontalAxis = hAxis.X

export(bool) var canJump = false
export(float) var jumpSpeed = 50
export(float) var jumpRate = .2
var isJumping: bool
var verticalVelocity:float

export(NodePath) var cameraPath
onready var camera: Camera = get_node(cameraPath)


func bool2float(boolean):
	if boolean:
		return 1.0
	return 0.0

func get_movement():
	var u:float
	var d:float
	var l:float
	var r:float
	
	var v:float
	var h:float
	
	u = bool2float(Input.is_action_pressed("tdUp"))
	d = bool2float(Input.is_action_pressed("tdDown"))
	l = bool2float(Input.is_action_pressed("tdLeft"))
	r = bool2float(Input.is_action_pressed("tdRight"))
	
	v = d - u
	h = r - l
		
		
	return {"h":h, "v":v}
	
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
	
	var inputs = get_movement()
	var velocity
	
	verticalVelocity = processVerticalMovement()
	
	#apply gravity
	if hasGravity:
		velocity = receiver.move_and_slide(Vector3(0, verticalVelocity, 0), Vector3.UP, false)

	#X Horizontal
	if horizontalAxis == hAxis.X:
		 velocity = receiver.move_and_slide(Vector3(maxSpeed * inputs.h, 0, 0), Vector3.UP, false)
	#Z Horizontal
	elif horizontalAxis == hAxis.Z:
		 velocity = receiver.move_and_slide(Vector3(0, 0, maxSpeed * inputs.h), Vector3.UP, false)


	return velocity

func _process(delta):
	if enabled:
		move()
