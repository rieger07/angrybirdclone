extends Node2D

enum SlingState {
	idle,
	pulling,
	birdThrown,
	reset
}

# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var SlingShotState
export (int) var MaxDistance = 100
export (int) var SpeedReduction = 50

var LeftLine
var RightLine
var CenterOfSlingShot
var Player

# Called when the node enters the scene tree for the first time.
func _ready():
	SlingShotState = SlingState.idle
	LeftLine = $LeftLine
	RightLine = $RightLine
	CenterOfSlingShot = $CenterOfSlingShot.position
	Player = get_tree().get_nodes_in_group("Player")[0]
	LeftLine.points[1] = CenterOfSlingShot
	RightLine.points[1] = CenterOfSlingShot	
	Player.position = CenterOfSlingShot
	
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	match SlingShotState:
		SlingState.idle:
			pass
		SlingState.pulling:
			if Input.is_mouse_button_pressed(BUTTON_LEFT):
				var distance = get_global_mouse_position()
				if distance.distance_to(CenterOfSlingShot) > MaxDistance:
					distance = (distance - CenterOfSlingShot).normalized() * MaxDistance + CenterOfSlingShot
				Player.position = distance
				LeftLine.points[1] = distance
				RightLine.points[1] = distance
			else:
				var location = get_global_mouse_position()
				var distance = location.distance_to(CenterOfSlingShot)
				var velocity = CenterOfSlingShot - location
				Player.ThrowBird()
				Player = Player as RigidBody2D
				Player.apply_impulse(Vector2(),velocity/SpeedReduction * distance)
				SlingShotState = SlingState.birdThrown
				LeftLine.points[1] = CenterOfSlingShot
				RightLine.points[1] = CenterOfSlingShot
				GameManager.CurrentGameState = GameManager.GameState.Play
			pass
		SlingState.birdThrown:
			pass
		SlingState.reset:
			pass
	pass


func _on_TouchArea_input_event(viewport, event, shape_idx):
	if SlingShotState == SlingState.idle:
		print("")
		if event is InputEventMouseButton && event.pressed:
			SlingShotState = SlingState.pulling
	pass # Replace with function body.
