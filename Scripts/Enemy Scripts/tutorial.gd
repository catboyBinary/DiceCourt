extends Node

onready var _menuScene = load("res://Scenes/MainMenu.tscn")

onready var dialogueBox = get_node("Player/Pivot/Camera/ColorRect")

onready var client = get_node("Client")
onready var dollarBills = get_node("Dollar_Bills")
onready var blackscreen = get_node("Player/Pivot/Camera/blackscreen")

onready var userCard = get_node("Interactables/UserCard")
onready var cardInfo = userCard.get_node("Viewport/Label")

onready var dice = get_node("Interactables/Dice")

onready var ledger = get_node("Interactables/Ledger")
onready var ledgerInfo = ledger.get_node("Viewport/Label")

onready var ledgerClosedMesh = preload("res://Assets/Misc/closedLedger.tres")
onready var ledgerOpenMesh = preload("res://Assets/Misc/openLedger.tres")

onready var tray = get_node("Interactables/Tray")
onready var bin = get_node("Interactables/Bin")

onready var player = get_node("Player")
onready var ui = get_node("Player/Pivot/Camera/Obj")
onready var result = get_node("Player/Pivot/Camera/ResultMsg")

onready var npcBasePath = 'res://Assets/Sprites/characters'
onready var bossPath = npcBasePath + '/boss'

var maleFirstNames = ['Michael', 'John', 'Bob', 'Jeff', 'Walter', 'Jessi', 'Ted', 'Mike', 'Fred']
var lastNames = ['Marley', 'Bolsa', 'Johansen', 'Corsa', 'Bobson', 'White', 'Mocanu']

var tutBox = 1


class userData:
	
	var gen: String
	var firstName: String
	var lastName: String
	var dateOfBirth: String
	var userNumber: String
	var notes: String
	
	var cheater:bool
	var briber:bool
	
	func _init(gen, firstName, lastName, userNumber, dateOfBirth, notes, cheater, briber):
		self.gen = gen
		self.firstName = firstName
		self.lastName = lastName
		
		self.userNumber = userNumber
		self.dateOfBirth = dateOfBirth
		
		self.notes = notes
		
		self.cheater = cheater
		self.briber = briber
				
	func getUserCard():
		var string:String
		string = self.firstName + ' ' + self.lastName + '\n        ' + self.userNumber + '\n        ' + self.dateOfBirth
		return string
	
	func getLedgerInfo():
		var string:String
		string = ''
		string = 'Name: ' + self.firstName + ' ' + self.lastName + '\nUser number:' + self.userNumber + '\nDate of birth:' + self.dateOfBirth
		return string
	
	func generateDate():
		var date:String = ''
		date += str(randi() % 31 + 1) + '/' + str(randi() % 12 + 1) + '/' + str(randi() % 30 + 1970)
		return date
	
	func getFakeLedgerInfo():
		var string:String
		string = ''
		
		var wrongType = randi() % 4
		
		match wrongType:
			0:
				var firstname
				var maleFirstNames = ['Michael', 'John', 'Bob', 'Jeff', 'Walter', 'Jessi', 'Ted', 'Mike', 'Fred']
				var femaleFirstNames = ['Evelyn', 'Joane', 'Amy', 'Anne', 'Mary']
				
				if self.gen == 'Male':
					firstName = maleFirstNames[randi() % maleFirstNames.size()]
				else:
					firstName = femaleFirstNames[randi() % femaleFirstNames.size()]	
					
				string = 'Name: ' + firstName + ' ' + self.lastName + '\nUser number:' + self.userNumber + '\nDate of birth:' + self.dateOfBirth
			
			1:
				
				var lastNames = ['Marley', 'Bolsa', 'Johansen', 'Corsa', 'Bobson', 'White', 'Mocanu']
				var lastName = lastNames[randi() % lastNames.size()]
				string = 'Name: ' + self.firstName + ' ' + lastName + '\nUser number:' + self.userNumber + '\nDate of birth:' + self.dateOfBirth
			
			2:
				var userNumber = str(randi() % 10000)
				string = 'Name: ' + self.firstName + ' ' + self.lastName + '\nUser number:' + userNumber + '\nDate of birth:' + self.dateOfBirth
			
			3:
				var dateOfBirth = generateDate()
				string = 'Name: ' + self.firstName + ' ' + self.lastName + '\nUser number:' + self.userNumber + '\nDate of birth:' + dateOfBirth
			
			
		return string

func generateDate():
	var date:String = ''
	date += str(randi() % 31 + 1) + '/' + str(randi() % 12 + 1) + '/' + str(randi() % 30 + 1970)
	return date

func generateTutorialUser():
	client.get_node("Sprite3D").texture = load(bossPath + '/boss_neutral.png')
	var gender = 'Male'
		
	var firstName = maleFirstNames[randi() % maleFirstNames.size()]
	var lastName = lastNames[randi() % lastNames.size()]
	
	var userNumber = str(randi() % 10000)
	var birthday = generateDate()

	var notes = ""
	
	var cheaterStatus = false
	var briberStatus = false
	
	var user = userData.new(gender, firstName, lastName, userNumber, birthday, notes, cheaterStatus, briberStatus)
	return user

var clientStatus = 0
var dinged = false

func createTutorialChar():
	var newUser = generateTutorialUser()
	var userCard = newUser.getUserCard()
	var ledgerData = newUser.getLedgerInfo()
	
	cardInfo.text = userCard
	ledgerInfo.text = ledgerData
	
	dice.rigged = true

	client.resetPos()
	client.comeIn()
	
var isCheater = false
var isBriber = false
var hadFirstClient = false


func done():
	client.leave()
	clientStatus = 0
	bin.hasDice = false	
	dice.translation = Vector3(0, 1, -1)
	dice.pickedUp = false
	userCard.translation = Vector3(0, -3, 0)
	userCard.moved = false
	dollarBills.returnBack()
	ledger.get_node("MeshInstance").mesh = ledgerClosedMesh
	ledger.get_node("Viewport/Label").text = ''
	dialogueBox.hide()

func proceed():
	blackscreen.color.a = 0
	blackscreen.get_node("Text").position = Vector2(0,1080)
	player.get_node("FPSMovement").enabled = true
	get_node("StaticObjects/clock").passedTime = 0
	get_node("StaticObjects/clock").currentHour = 18
	get_node("StaticObjects/clock").currentMinute = 0
	get_node("StaticObjects/clock").active = true
	
	$Music.play()
	$DayEnd.stop()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pass

func _ready():
	randomize()
	ledger.get_node("MeshInstance").mesh = ledgerOpenMesh
	createTutorialChar()
	dice.translation = dice.originalPos
	
	var diceMesh = dice.get_node("MeshInstance")
	diceMesh.set_surface_material(0, dice.diceMats[randi() % 7])
	diceMesh.get_surface_material(0).set_next_pass(dice.outline)
	
	bin.hasDice = false
	
	userCard.translation = userCard.originalPos
	
	dialogueBox.bringUp()
	dialogueBox.setTut(tutBox)
	
	
	clientStatus = 1
	

func _process(delta):
	if dinged:
		tutBox += 1
		dialogueBox.setTut(tutBox)
		dinged = false
		if tutBox >= 14:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
			get_tree().change_scene_to(_menuScene)
		
