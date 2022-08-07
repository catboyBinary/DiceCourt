extends RigidBody

onready var bodiesEntered = 0
onready var pickedUp = false

onready var hasDice = false
onready var dice = null

onready var outline = preload('res://Assets/3D Models/more mats/outline.tres')

var originalPos

func _ready():
	originalPos = global_transform.origin

func setUpright():
	rotation = Vector3(0,0,0)
	
func turnAround():
	rotation += Vector3(0,0,PI)
	if dice != null:
		dice.mode = RigidBody.MODE_RIGID
		dice.setShakerSide()
		dice.global_transform.origin -= Vector3(0,0.5,0)
		hasDice = false
		dice = null

func setRot():
	if mode == RigidBody.MODE_RIGID && pickedUp:
		mode = RigidBody.MODE_KINEMATIC

func _on_TestArea_area_entered(area):
	if area.name == "Water":
		
		if !get_node("Splash").is_playing():
			get_node("Splash").play()
			

func _process(delta):
	print(pickedUp)
	
	if hasDice:
		dice.global_transform.origin = global_transform.origin + Vector3(0,0.3,0)

	if Input.is_action_just_pressed("useShaker") && pickedUp:
		turnAround()
		
	if mode == RigidBody.MODE_KINEMATIC and !pickedUp:
		mode == RigidBody.MODE_RIGID
		

func _on_Area_body_entered(body):
	if body.name == 'Dice':
		dice = body
		hasDice = true
		body.mode = RigidBody.MODE_KINEMATIC
