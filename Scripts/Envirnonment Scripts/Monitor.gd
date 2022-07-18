extends StaticBody

var unbiased = preload("res://Assets/Sprites/diceXray/Unbiased.png")
var biased = [preload("res://Assets/Sprites/diceXray/Biased_1.png"), preload("res://Assets/Sprites/diceXray/Biased_2.png"),
			preload("res://Assets/Sprites/diceXray/Biased_3.png"), preload("res://Assets/Sprites/diceXray/Biased_4.png"),
			preload("res://Assets/Sprites/diceXray/Biased_5.png")]


# Called when the node enters the scene tree for the first time.
func _ready():
	$Sprite3D.texture = null

func setTex(type):
	if type == 0:
		$Sprite3D.texture = unbiased
	else:
		var img = randi() % 5
		$Sprite3D.texture = biased[img]
