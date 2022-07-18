extends Node

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
onready var money = get_node("Player/Pivot/Camera/Money")
onready var dollars = 0
onready var caughtCheaters = 0
onready var missedCheaters = 0
onready var customers = 0
onready var declinedCustomers = 0

onready var npcBasePath = 'res://Assets/Sprites/characters'

onready var bossPath = npcBasePath + '/boss'
onready var man1Path = npcBasePath + '/char1'
onready var man2Path = npcBasePath + '/man'
onready var policePath = npcBasePath + '/police'

onready var woman1Path = npcBasePath + '/woman'
onready var woman2Path = npcBasePath + '/woman2'
onready var kidsPath = npcBasePath + '/kids'


var genders = ['Male', 'Female']

var maleFirstNames = ['Michael', 'John', 'Bob', 'Jeff', 'Walter', 'Jessi', 'Ted', 'Mike', 'Fred']
var femaleFirstNames = ['Evelyn', 'Joane', 'Amy', 'Anne', 'Mary']

var lastNames = ['Marley', 'Bolsa', 'Johansen', 'Corsa', 'Bobson', 'White', 'Mocanu']

var additionalNotes = ['Big spender', 'Suspected of cheating', 'Trouble maker', 'Generous gambler']

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

func generateUser():
	var index = randi() % 10
	var gender
	if index > 7:
		gender = 'Female'
	else:
		gender = 'Male'
	
	
	if gender == 'Female':
		var skin = randi() % 2
		match skin:
			0:
				client.get_node("Sprite3D").texture = load(woman1Path + '/woman1_neutral.png')
			1:
				client.get_node("Sprite3D").texture = load(woman2Path + '/woman2_neutral.png')	
			
	else:
		var skin = randi() % 5
		match skin:
			0:
				client.get_node("Sprite3D").texture = load(bossPath + '/boss_neutral.png')
			1:
				client.get_node("Sprite3D").texture = load(man1Path + '/char1_neutral.png')
			2:
				client.get_node("Sprite3D").texture = load(man2Path + '/man1_neutral.png')
			3:
				client.get_node("Sprite3D").texture = load(policePath + '/police_neutral.png')
			4:
				client.get_node("Sprite3D").texture = load(kidsPath + '/kids_neutral.png')
		
			
	var firstName
	if gender == 'Male':
		firstName = maleFirstNames[randi() % maleFirstNames.size()]
	else:
		firstName = femaleFirstNames[randi() % femaleFirstNames.size()]		
		
	var lastName = lastNames[randi() % lastNames.size()]
	
	var userNumber = str(randi() % 10000)
	var birthday = generateDate()

	var notes = additionalNotes[randi() % additionalNotes.size()]
	
	#cheater status
	var cheaterChance = randf()
	var briberChance = randf()
	var cheaterStatus = false
	var briberStatus = false
	if cheaterChance > 0.7:
		cheaterStatus = true
		if briberChance > 0.7:
			briberStatus = true
	
	var user = userData.new(gender, firstName, lastName, userNumber, birthday, notes, cheaterStatus, briberStatus)
	return user

var clientStatus = 0
var dinged = false

func createNewClient():
	#get client data
	var newUser = generateUser()
	var userCard = newUser.getUserCard()
	var ledgerData = newUser.getLedgerInfo()
	
	cardInfo.text = userCard
	ledgerInfo.text = ledgerData
	
	if newUser.cheater == true:
		isCheater = true
		if newUser.briber == true:
			isBriber = true
		
		var cheaterType = randf()
		
		if cheaterType > 0.8:
			ledgerData = newUser.getFakeLedgerInfo()
			ledgerInfo.text = ledgerData
		else:
			dice.rigged = newUser.cheater
	else:
		isCheater = false
		isBriber = false
		dice.rigged = false
	
	
	dialogueBox.isCheater = isCheater
	dialogueBox.isBriber = isBriber
	
	client.resetPos()
	client.comeIn()
	if isBriber:
		dollarBills.moveIn()

var isCheater = false
var isBriber = false
var hadFirstClient = false

func getPaid(amount : int):
	dollars += amount
	money.text = str(dollars)

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

func endDay():
	blackscreen.get_node("Tween").interpolate_property(blackscreen, "color:a", 0, 1, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	blackscreen.get_node("Tween").interpolate_property(blackscreen.get_node("Text"), "position", Vector2(0, 1080), Vector2.ZERO, 1, Tween.TRANS_SINE, Tween.EASE_OUT, 0.25)
	player.get_node("FPSMovement").enabled = false
	player.get_node("Pivot").rotation_degrees = Vector3.ZERO 
	blackscreen.get_node("Tween").start()
	done()
	
	var caught = (randi() % 20 + 10) * caughtCheaters
	var missed = (randi() % 20 - 45) * missedCheaters
	var declined = (randi() % 10 - 25) * declinedCustomers
	var rent = randi() % 120 + 150
	getPaid(-rent)
	getPaid(caught)
	getPaid(missed)
	getPaid(declined)
	
	blackscreen.get_node("Text/caught").text = "Cheaters Caught: " + str(caughtCheaters)
	blackscreen.get_node("Text/missed").text = "Cheaters Missed " + str(missedCheaters)
	blackscreen.get_node("Text/declined").text = "Customers Declined: " + str(declinedCustomers)
	blackscreen.get_node("Text/customers").text = "Customers Accepted: " + str(customers)
	blackscreen.get_node("Text/Money").text = "Total money: " + str(dollars)
	blackscreen.get_node("Text/rent").text = "House Rent: " + str(rent)

	$Music.stop()
	$DayEnd.play()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
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
	ui.bbcode_text = "Current objective:\nDing the bell to call next client"
	result.bbcode_text = ""
	

func _process(delta):
	randomize()
	
	#print(clientStatus)
	
	if dinged:
		#client enters
		if clientStatus == 0:
			
			ledger.get_node("MeshInstance").mesh = ledgerOpenMesh
			
			hadFirstClient = true
			dollarBills.returnBack()
			ui.bbcode_text = "Current objective:\nInspect the dice and the card"
			result.bbcode_text = ""
			createNewClient()
			clientStatus = 1
			
			var diceMesh = dice.get_node("MeshInstance")
			diceMesh.set_surface_material(0, dice.diceMats[randi() % 7])
			diceMesh.get_surface_material(0).set_next_pass(dice.outline)
			
			
			bin.hasDice = false
			dice.translation = dice.originalPos
			userCard.translation = userCard.originalPos
			
			dialogueBox.bringUp()
			dialogueBox.setGreeting()
			
		#client leaves
		elif clientStatus == 1 && userCard.moved == false && ((tray.moved == false && tray.hasDice == true) or bin.hasDice == true):
			
			ledger.get_node("MeshInstance").mesh = ledgerClosedMesh
			ledger.get_node("Viewport/Label").text = ''
			
			ui.bbcode_text = "Current objective:\nDing the bell to call next client"
			client.leave()
			clientStatus = 0
			
			if hadFirstClient:
				if isCheater && tray.hasDice:
					dialogueBox.setAccepted()
					#result.bbcode_text = "You let a cheater through"
					missedCheaters += 1
					if isBriber: 
						dollarBills.giveToPlayer()
						getPaid(randi() % 30 + 30)
				elif isCheater && !tray.hasDice:
					#result.bbcode_text = "You caught a cheater"
					dialogueBox.setRejected()
					caughtCheaters += 1
					dollarBills.returnBack()
				elif !isCheater && tray.hasDice:
					#result.bbcode_text = "You let a legit customer in"
					dialogueBox.setAccepted()
					customers += 1
					dollarBills.returnBack()
				elif !isCheater && !tray.hasDice:
					#result.bbcode_text = "You denied a legit customer"
					dialogueBox.setRejected()
					declinedCustomers += 1
					dollarBills.returnBack()
				var payment = randi() % 10 + 10
				print(payment)
				getPaid(payment)
					
			
			bin.hasDice = false
				
			dice.translation = Vector3(0, 1, -1)
			userCard.translation = Vector3(0, -3, 0)
			userCard.moved = false
			
			
		else:
			ui.bbcode_text = "To continue, the user card must be near the client\nand the dice on the tray near him\nor in the bin"
					

		dinged = false
