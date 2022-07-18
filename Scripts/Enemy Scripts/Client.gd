extends Spatial

onready var originalPos = global_transform.origin
onready var midPos = global_transform.origin + Vector3(5,0,0)
onready var exitPos = global_transform.origin + Vector3(10,0,0)

func resetPos():
	translation = originalPos

func comeIn():
	$Tween.interpolate_property(self, "translation", originalPos, midPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)	
	$Tween.start()

func leave():
	$Tween.interpolate_property(self, "translation", midPos, exitPos, 0.5, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	$Tween.start()
	
func move(): 
	$Tween.start()
