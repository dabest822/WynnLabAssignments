extends Sprite2D

# Called every frame
func _process(delta):
	if Input.is_action_pressed("ui_right"):  # Right arrow key is pressed
		position.x += 200 * delta  # Move right
		$AnimationPlayer.play("Walk_Right")  # Play walk right animation
	elif Input.is_action_pressed("ui_left"):  # Left arrow key is pressed
		position.x -= 200 * delta  # Move left
		$AnimationPlayer.play("Walk_Left")  # Play walk left animation
	else:
		$AnimationPlayer.stop()  # Stop animation when no key is pressed
