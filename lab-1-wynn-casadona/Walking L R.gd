extends Sprite2D

var speed = 200  # Walking speed
var run_speed = 400  # Running speed
var is_running = false  # Flag to track running state
var facing_direction = "right"  # Tracks player's direction

func _process(delta):
	var current_speed = speed  # Default to walking speed
	
	# Check if the Shift key (run action) is pressed
	if Input.is_action_pressed("run"):
		is_running = true
		current_speed = run_speed  # Set to running speed
		print("Running at speed: ", run_speed)
	else:
		is_running = false
		current_speed = speed  # Reset to walking speed
		print("Walking at speed: ", speed)
	
	# Move and animate based on direction and running state
	if Input.is_action_pressed("ui_right"):  # Move right
		position.x += current_speed * delta
		facing_direction = "right"  # Update facing direction
		if is_running:
			print("Running to the right")
			$AnimationPlayer.play("Run_Right")  # Play running animation
		else:
			print("Walking to the right")
			$AnimationPlayer.play("Walk_Right")  # Play walking animation

	elif Input.is_action_pressed("ui_left"):  # Move left
		position.x -= current_speed * delta
		facing_direction = "left"  # Update facing direction
		if is_running:
			print("Running to the left")
			$AnimationPlayer.play("Run_Left")  # Play running animation
		else:
			print("Walking to the left")
			$AnimationPlayer.play("Walk_Left")  # Play walking animation

	else:
		# If no movement input, set the idle animation based on facing direction
		if facing_direction == "right":
			$AnimationPlayer.play("Idle_Right")
		else:
			$AnimationPlayer.play("Idle_Left")
