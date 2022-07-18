extends RigidBody

onready var bodiesEntered = -1
onready var pickedUp = true

onready var wet = 0
onready var waterTimer = 0
onready var spinTimer = 0

onready var rigged = false

onready var plainDice = preload('res://Assets/3D Models/more mats/plain.tres')
onready var islandsDice = preload('res://Assets/3D Models/more mats/islands.tres')
onready var lunarDice = preload('res://Assets/3D Models/more mats/lunar.tres')
onready var sunDice = preload('res://Assets/3D Models/more mats/sun.tres')
onready var duneDice = preload('res://Assets/3D Models/more mats/dunes.tres')
onready var marbleDice = preload('res://Assets/3D Models/more mats/marble.tres')
onready var spartanDice = preload('res://Assets/3D Models/more mats/spartan.tres')

onready var diceMats = [plainDice, islandsDice, lunarDice, sunDice, duneDice, marbleDice, spartanDice]

onready var outline = preload('res://Assets/3D Models/more mats/outline.tres')

var originalPos

var faces = [Vector3(0, 0, -90), Vector3(90, 0, 0), Vector3(0, 0, 90), Vector3(-90, 0, 0), Vector3(0, 0, 0), Vector3(0, 0, 180)] 

onready var fallingFace = faces[0]

func _ready():
	originalPos = global_transform.origin
	translation = Vector3(0, -1, 0)

func setRot():
	if mode == RigidBody.MODE_RIGID:
		mode = RigidBody.MODE_KINEMATIC
	
	rotation = fallingFace

func setUpright():
	rotation = faces[4]

func _physics_process(delta):
	if waterTimer > 0:
		waterTimer -= 1
	
	if waterTimer == 0 and wet:
		setRot()


func _on_TestArea_body_entered(body):
	bodiesEntered += 1

	

func _on_TestArea_body_exited(body):
	bodiesEntered -= 1


func _on_TestArea_area_entered(area):
	if area.name == "Water":
		
		if !get_node("Splash").is_playing():
			get_node("Splash").play()
			
		#choosing the face to print
		var face = randi() % 6
		if rigged and face < 3:
			face += 2
		fallingFace = faces[face]
		waterTimer = 120 
		wet = true
		


func _on_TestArea_area_exited(area):
	if area.name == "Water":
		wet = false

