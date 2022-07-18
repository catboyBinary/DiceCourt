extends StaticBody

onready var originalPos = Vector3(0,0,0)
onready var newPos = Vector3(0,0,deg2rad(60))

onready var hasDice = false

func _on_Area_body_entered(body):
	if body.name == 'Dice':
		$Tween.interpolate_property($Flap, "rotation", originalPos, newPos, 0.5, Tween.TRANS_SINE, Tween.EASE_OUT)
		$Tween.interpolate_property($Flap, "rotation", newPos, originalPos, 0.7, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 1)
		$Tween.start()
		if !get_node("FlapSound").is_playing():
			get_node("FlapSound").play()


func _on_DiceEater_body_entered(body):
	if body.name == 'Dice':
		hasDice = true
