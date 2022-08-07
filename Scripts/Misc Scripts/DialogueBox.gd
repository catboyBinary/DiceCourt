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
	waitingTimer = 34
	
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
	waitingTimer = 40

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

func setTut(x):
	match(x):
		1:
			$Text.bbcode_text = "Hey kid, the boss told me to give you a quick run-down of the job. He also told me you are a bit slow, so when you want me to move to the next point, simply ding the bell (LMB)."
		2:
			$Text.bbcode_text = "Ok, so the first thing you need to know is that people come here with 2 things: their user card and die, either of them possibly being fake. Let's start with the user card."
		3:
			$Text.bbcode_text = "First, you can drag it towards you using LMB. You can also zoom in using RMB. Now, that ledger to your left shows the information we have on that person. That info needs to match the one on the card. If it doesn't you need to reject that poser."
		4:
			$Text.bbcode_text = "Even if the card info is ok, that doesn't mean that dude is cool. You need to check his die. The fastest way to do it is using the dice shaker. Use LMB to pick the die and drop it in the cup (LMB again)"
		5:
			$Text.bbcode_text = "After the die is in the cup use LMB on the cup to pick it up. Now, to throw the die, you press F to flip the shaker. As you might expect, this method is not really reliable, as sometimes you just get lucky, but it's quick."	
		6:
			$Text.bbcode_text = "The next option you have, is using the water tank. If you put a die in there and let it sit until it stops moving, it will float on a face. Rigged dice tend to float with bigger faces up. This method is slower, but more reliable."
		7:
			$Text.bbcode_text = "Lastly, you have the xray machine. That bad boy can find any tampering with dice, but it's very slow. A real pro doesn't need it, and it also tends to take so long, that clients just leave, but sometimes it's better to be safe than sorry."
		8:
			$Text.bbcode_text = "In order to use the xray machine, open the it's door(LMB), put the die inside, close the door, then press the big red button. After it's done doing its thing, you'll see a picture on the screen. If there appears to be something inside, the die is rigged."
		9:
			$Text.bbcode_text = "Ok, now you know how to identify a cheater, but what to do when you find one? Throw his die in the bin to your right, give him his card back and ding him away."
		10:
			$Text.bbcode_text = "If after all you consider that person legit, put his die on the tray and give it and the card back to him, then ring the bell."
		11:
			$Text.bbcode_text = "Keep in mind that speed is of essence, people don't like waiting around and if you take too long they will leave. That doesn't mean you should rush things, but that you shouldn't waste time... If you want to keep your job."
		12:
			$Text.bbcode_text = "Your shift ends at 00:00, so you want to get through as many clients as possible."
		13:
			$Text.bbcode_text = "Alright, that's all, you're set. I also placed some sticky notes around so you can refresh your memory at any time. When you are ready to start your first shift, ding the bell one last time. Good luck!"
			
func _on_Button_pressed():
	hide()
	gameController.proceed()
