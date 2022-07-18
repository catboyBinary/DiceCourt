extends StaticBody

onready var monitor = get_node('../../Monitor')
onready var tween = get_node('../Tween')
onready var door = get_node("../Door")
onready var diceBlocker = get_node('../DiceBlocker/CollisionShape')

onready var status = 'insert dice'
onready var pressed = false

onready var diceInArea = false
onready var dice = null

onready var doorOpen = false

var proccessingTimer = 0


onready var doorStartPos = door.translation
onready var doorEndPos = door.translation + Vector3(0,0,-0.25)

func moveDoor():
	if !doorOpen:
		if status != 'processing':
			tween.interpolate_property(door, "translation", doorStartPos, doorEndPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
			doorOpen = true
			diceBlocker.disabled = true
	else:
		tween.interpolate_property(door, "translation", doorEndPos, doorStartPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		doorOpen = false
		if !diceInArea:
			diceBlocker.disabled = false
		
	tween.start()


func _process(delta):
	get_node("../Viewport/Label").text = status
	
	if diceInArea == false:
		status = 'insert dice'	
	elif diceInArea and dice.mode == RigidBody.MODE_RIGID && status != 'done':
		if !doorOpen:
			status = 'waiting'
		else:
			status = 'close door'
	
	if pressed == true:
		print("PRESSED")
		if !get_node("../Click").is_playing():
			get_node("../Click").play()
		if status == 'waiting':
			proccessingTimer = 900
		pressed = false

	if proccessingTimer > 0:
		
		if !get_node("../BuzzingSound").is_playing():
			get_node("../BuzzingSound").play()

		status = 'processing'
		proccessingTimer -= 1
		if proccessingTimer == 0:
			status = 'done'
			
			if get_node("../BuzzingSound").is_playing():
				get_node("../BuzzingSound").stop()
			
			if dice.rigged == false:
				monitor.setTex(0)
			else:
				monitor.setTex(1)
			

func _on_DiceArea_body_entered(body):
	if body.name == 'Dice':
		diceInArea = true
		dice = body

func _on_DiceArea_body_exited(body):
	if body.name == 'Dice':
		diceInArea = false
		dice = null
