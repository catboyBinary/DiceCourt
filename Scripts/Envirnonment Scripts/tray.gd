extends KinematicBody

onready var moved = false
onready var hasDice = false
onready var isHovered = false

onready var originalPos = global_transform.origin
onready var newPos = global_transform.origin + Vector3(0,0,2)

func drag():
	
	if !get_node("Sliding").is_playing():
		get_node("Sliding").play()
	else:
		get_node("Sliding").stop()
		get_node("Sliding").play()
		
	if moved:
		$Tween.interpolate_property(self, "translation", originalPos, newPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	else: 
		$Tween.interpolate_property(self, "translation", newPos, originalPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
		
	$Tween.start()



func _on_DiceChecker_body_entered(body):
	if body.name == "Dice":
		hasDice = true


func _on_DiceChecker_body_exited(body):
	if body.name == "Dice":
		hasDice = false	
