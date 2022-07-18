extends StaticBody

onready var originalPos = Vector3(0,0,0)
onready var newPos = Vector3(0,0,deg2rad(60))

onready var hasDice = false

var cooldown = 0
var state = 'closed'

func _process(delta):
	if cooldown > 0:
		cooldown -= 1
	
	if cooldown == 0 and state == 'open':
		$Tween.interpolate_property($Flap, "rotation", newPos, originalPos, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		state = 'closed'
		
func _on_Area_body_entered(body):
	if body.name == 'Dice' && cooldown <= 0 && state == 'closed':
		$Tween.interpolate_property($Flap, "rotation", originalPos, newPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		$Tween.start()
		cooldown = 120
		state = 'open'
		if !get_node("FlapSound").is_playing():
			get_node("FlapSound").play()


func _on_DiceEater_body_entered(body):
	hasDice = true


func _on_DiceEater_body_exited(body):
	hasDice = false
