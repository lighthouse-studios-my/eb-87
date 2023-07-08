extends CharacterBody2D


@export var speed = 400  # speed in pixels/sec


func _physics_process(delta):
	var direction = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = direction * speed
	
	move_and_slide()

func _unhandled_input(event: InputEvent):
	if event.is_action_pressed("dodge"):
		print("test")
