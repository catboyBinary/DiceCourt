extends TextureRect

export(NodePath) var gameControllerPath
onready var gameController = get_node(gameControllerPath)

onready var greetings = ['Good day sir, it’s lovely seeing you again. How is your family doing?',
						'Tough times we’ve been having, but you know what they say, tough people outlast the tough times.',
						'What a spell of weather we’ve been having, though I don’t suppose you get to see it from in here.',
						'Yo wassup homie, how’s it going.',
						'Greetings for the day!',
						'Hey man, long time no see.',
						'It’s been a while, how’re you keeping?',
						'Hey, good to see you again!']

onready var susGreetings = ['I’m feeling lucky, how about you?',
							'I think today’s my lucky day!',
							'I’ve brought my lucky clover with me today.']
							
onready var briberGreetings =  ['Consider this… a gift.',
								'Here, take this as a… reward for your time.',
								'What happens at this desk stays at this desk.',
								'I think I have a business arrangement, that could be.. profitable for both of us.',
								'If you saw nothing, neither did I.']
							
onready var accepted = ['Well thank you, enjoy the rest of your day.',
						'Thank you, see you round!',
						'Catch you later!',
						'Good day sir!',
						'See you later!']
						
onready var rejected = ['How rude!',
						'I will not be visiting this establishment again!',
						'I will be contacting your manager!',
						'Not cool man, not cool.',
						'What a preposterous accusation!']
						
onready var susRejected = ['Well you have your wits about you!',
							'Dangit!',
							'You can\'t just do that!']

onready var waiting = ['What’s taking so long?',
						'Slow and steady wins the race eh?',
						'So I was reading an article the other day…']

onready var susWaiting = ['Is there a problem sir?',
							'Come on man, I’ve not got very long.',
							'Hurry up, I’ve got places to go!',
							'Can’t you go any faster?']

onready var waitingTimer = 0

var dialogueType = 'none'
var isCheater
var isBriber

var hidden = false
var normalPos
func _ready():
	normalPos = rect_position
	hide()
	
func bringUp():
	rect_position = normalPos
	hidden = false

func hide():
	rect_position = Vector2(rect_position.x, 10000)
	hidden = true
	dialogueType = 'none'

func setGreeting():
	var greetingType = randi() % 10
	var messageModifier
	
	if isCheater:
		messageModifier = 6
	else:
		messageModifier = 8
	
	if greetingType < messageModifier:
		$Text.bbcode_text = greetings[randi() % greetings.size()]
	else:
		$Text.bbcode_text = susGreetings[randi() % susGreetings.size()]	
	if isBriber:
		$Text.bbcode_text = briberGreetings[randi() % briberGreetings.size()]	
		
	dialogueType = 'greeting'
	waitingTimer = 26
	
func setRejected():
	var greetingType = randi() % 10
	var messageModifier
	
	if isCheater:
		messageModifier = 6
	else:
		messageModifier = 8
	
	if greetingType < messageModifier:
		$Text.bbcode_text = rejected[randi() % rejected.size()]
	else:
		$Text.bbcode_text = susRejected[randi() % susRejected.size()]	
	if isBriber:
		$Text.bbcode_text = susRejected[randi() % susRejected.size()]	
		
	dialogueType = 'rejected'
	waitingTimer = 3
	
func setAccepted():
	$Text.bbcode_text = accepted[randi() % accepted.size()]	
		
	dialogueType = 'accepted'
	waitingTimer = 3


func setWaiting():
	var waitingType = randi() % 10
	
	var messageModifier
	
	if isCheater:
		messageModifier = 6
	else:
		messageModifier = 8
	
	if waitingType < messageModifier:
		$Text.bbcode_text = waiting[randi() % waiting.size()]
	else:
		$Text.bbcode_text = susWaiting[randi() % susWaiting.size()]	
	if isBriber:
		$Text.bbcode_text = susWaiting[randi() % susWaiting.size()]	
	
	gameController.getPaid(-5)
	dialogueType = 'waiting'
	waitingTimer = 32

func _process(delta):
	if !hidden and waitingTimer <= 0 && dialogueType == 'greeting':
		setWaiting()
	if !hidden and waitingTimer <= 0 && dialogueType == 'waiting':
		gameController.done()
		dialogueType = 'done'
	if !hidden and waitingTimer <= 0 && (dialogueType == 'rejected' or dialogueType == 'accepted'):
		hide()
		dialogueType = 'done'
	
	if waitingTimer > 0:
		waitingTimer -= delta


func _on_Button_pressed():
	hide()
	gameController.proceed()
