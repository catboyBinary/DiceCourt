extends Node

export(NodePath) var playerPath
onready var player:KinematicBody = get_node(playerPath)

export(NodePath) var interactorPath
onready var interactor:RayCast = get_node(interactorPath)

onready var root = get_tree().root.get_child(0)

onready var tray = root.get_child(4).get_child(1)
onready var card = root.get_child(4).get_child(2)
onready var bell = root.get_child(4).get_child(3)
onready var waterTank = root.get_child(4).get_child(4)
onready var xray = root.get_child(4).get_child(6)
onready var bin = root.get_child(4).get_child(8)
onready var interactables = [tray, bell, bin, card, xray, waterTank]

var holdingItem = false
var heldItem = false

func get_interactable():
	return interactor.get_collider()


func _process(_delta):
	var interactedObj = get_interactable()
	
	#dropping dice
	if Input.is_action_just_pressed("click") && holdingItem && heldItem.bodiesEntered == 0:
		heldItem.get_node("MeshInstance").get_active_material(0).get_next_pass().set_shader_param("color", Color(0, 0, 0, 0))
		heldItem.mode = RigidBody.MODE_RIGID
		heldItem.pickedUp = false
		holdingItem = false
		heldItem = null
	#otherwise
	else:
		#if hand is empty
		if interactedObj != null && !holdingItem:
			
			
			if interactedObj.name == 'Dice':
				
				if Input.is_action_just_pressed("click"):
					holdingItem = true
					heldItem = interactedObj
					heldItem.mode = RigidBody.MODE_KINEMATIC
					heldItem.setUpright()
			
					heldItem.pickedUp = true
			
			
			if interactedObj.name == 'Door':
				var xrayInteractor = xray.get_node('Button')
				if Input.is_action_just_pressed("click"):
					xrayInteractor.moveDoor()
			
			if interactedObj.name == 'UserCard' or interactedObj.name == 'Tray':
				interactedObj.isHovered = true	
				if Input.is_action_just_pressed("click"):
					interactedObj.moved = !interactedObj.moved
					interactedObj.drag()
	
			if interactedObj.name == 'Button' or interactedObj.name == 'Bell':
				
				if Input.is_action_just_pressed("click"):
					interactedObj.pressed = true
		
		
		for item in interactables:
			item.get_node("Mesh").get_active_material(0).get_next_pass().set_shader_param("color", Color(0, 0, 0, 0))
		
		if interactedObj in interactables:
			interactedObj.get_node("Mesh").get_active_material(0).get_next_pass().set_shader_param("color", Color(255, 255,255, 0))
		
					
					
	if holdingItem:
		heldItem.get_node("MeshInstance").get_active_material(0).get_next_pass().set_shader_param("color", Color(255, 255,255, 0))
	
		heldItem.global_transform.origin = lerp(heldItem.global_transform.origin, interactor.get_node("HeldPlace").global_transform.origin, 0.2)
				
				
