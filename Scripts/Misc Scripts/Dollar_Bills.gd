extends Spatial

var startpos = Vector3(0,3,-1)
var tablepos1 = Vector3(0,4.2,-1)
var tablepos2 = Vector3(0,4.2,1)
var playerpos = Vector3(0,4.2,5)

func _ready():
	pass # Replace with function body.
	
func moveIn():
	$Tween.seek(10)
	$Tween.interpolate_property(self, "translation", startpos, tablepos1, 0.75, Tween.TRANS_SINE, Tween.EASE_IN_OUT, 0.25)
	$Tween.interpolate_property(self, "translation", tablepos1, tablepos2, 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 1)
	$Tween.start()

func returnBack():
	$Tween.interpolate_property(self, "translation", tablepos2, startpos, 0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()
	
func giveToPlayer():
	$Tween.interpolate_property(self, "translation", tablepos2, playerpos, 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN)
	$Tween.interpolate_property(self, "translation", playerpos, startpos, 0, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT,0.75)
	$Tween.start()
