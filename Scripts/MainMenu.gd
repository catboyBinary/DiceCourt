extends Node2D

var starttime = OS.get_ticks_msec()
var config = ConfigFile.new()
onready var _gameScene = preload("res://Scenes/TestScene.tscn")
onready var tween = $Camera2D/Tween

func _ready():
	splash()
	var err = config.load("user://config.ini")
	if err != OK:
		saveConfig(50, 50)
	$Screen2/Music.value = config.get_value("Volume", "Music")
	$Screen2/SFX.value = config.get_value("Volume", "SFX")
	updateValues()
	
func _process(delta):
	if Input.is_action_just_pressed("ui_accept") and OS.get_ticks_msec() - starttime < 8200 and $Music.get_playback_position() < 8.2:
		$Music.seek(8.2)
		tween.seek(8.2)

func saveConfig(music : int, sfx : int):
	config.set_value("Volume", "Music", music)
	config.set_value("Volume", "SFX", sfx)
	config.save("user://config.ini")
	
func updateValues():
	AudioServer.set_bus_volume_db(1, linear2db($Screen2/Music.value/100))
	AudioServer.set_bus_volume_db(2, linear2db($Screen2/SFX.value/100))
	$Screen2/Music/Percentage.text = str($Screen2/Music.value) + "%"
	$Screen2/SFX/Percentage.text = str($Screen2/SFX.value) + "%"
	
func splash():
	tween.interpolate_property($Camera2D, "position", Vector2(-3840,0), Vector2(-1920,0),2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT)
	tween.interpolate_property($Splash/Godot/Sprite, "rotation_degrees", 0, 360, 2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,1)
	tween.interpolate_property($Camera2D, "position", Vector2(-1920,0), Vector2(-1920,-1080),2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,2.1)
	tween.interpolate_property($Splash/GMTK/Sprite, "scale:x", 0, 0.35, 2, Tween.TRANS_ELASTIC, Tween.EASE_OUT, 3.35)
	tween.interpolate_property($Camera2D, "position", Vector2(-1920,-1080), Vector2(0,-1080),2,Tween.TRANS_ELASTIC,Tween.EASE_IN_OUT,4.2)
	tween.interpolate_property($Camera2D/Background, "modulate:a", 0, 1, 3, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 6.3)
	tween.interpolate_property($Camera2D, "position", Vector2(0,-1080), Vector2.ZERO,3,Tween.TRANS_SINE,Tween.EASE_IN_OUT,6.3)
	tween.start()

func _on_Options_pressed():
	$Camera2D/Tween.interpolate_property($Camera2D, "position", Vector2.ZERO, Vector2(1920, 0), 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Camera2D/Tween.start()


func _on_Back_pressed():
	saveConfig($Screen2/Music.value, $Screen2/SFX.value)
	$Camera2D/Tween.interpolate_property($Camera2D, "position", Vector2(1920, 0), Vector2.ZERO, 0.75, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Camera2D/Tween.start()


func _on_Credits_pressed():
	$Camera2D/Tween.interpolate_property($Camera2D, "position", Vector2.ZERO, Vector2(0, 1080), 1, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT)
	$Camera2D/Tween.interpolate_property($Camera2D, "position", Vector2(0, 1080), Vector2(0, 2160), 8, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT, 1)
	$Camera2D/Tween.interpolate_property($Camera2D, "position", Vector2(0, 2160), Vector2.ZERO, 1.25, Tween.TRANS_CUBIC, Tween.EASE_IN_OUT, 11)
	$Camera2D/Tween.start()


func _on_Music_value_changed(value):
	updateValues()

func _on_SFX_value_changed(value):
	updateValues()

func _on_Exit_pressed():
	get_tree().quit()


func _on_Play_pressed():
	get_tree().change_scene_to(_gameScene)
