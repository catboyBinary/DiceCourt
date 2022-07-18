extends StaticBody

onready var pressed = false
onready var clientGenerator = get_parent().get_parent()

onready var dingSound = preload('res://Assets/Sounds/SFX/bell.wav')
onready var cooldown = 0

func _process(delta):
	if pressed && cooldown == 0:
		cooldown = 120
		clientGenerator.dinged = true
		pressed = false
		if !$AudioStreamPlayer.is_playing():
			$AudioStreamPlayer.stream = dingSound
			$AudioStreamPlayer.play()
	
	if cooldown > 0:
		cooldown -= 1
