extends Sprite2D

var velocity = Vector2()  # Store velocity for movement
var gravity = 1200  # Gravity force to pull the player down
var jump_force = -600  # Adjusted jump force for lower jump height
var speed = 300  # Increased horizontal movement speed
var is_jumping = false  # Track if the player is in the air
var in_air = false  # Track if the character is mid-air
var facing_direction = "right"  # Track which direction the player is facing
var ground_y = 540  # Adjusted Y position of the ground

# Called every frame
func _process(delta):
	if not is_jumping and not in_air:  # Regular ground movement when not jumping
		if Input.is_action_pressed("ui_right"):  # Move right
			position.x += speed * delta
			facing_direction = "right"  # Remember the player is facing right
			$AnimationPlayer.play("Walk_Right")  # Play walk right animation
		elif Input.is_action_pressed("ui_left"):  # Move left
			position.x -= speed * delta
			facing_direction = "left"  # Remember the player is facing left
			$AnimationPlayer.play("Walk_Left")  # Play walk left animation
		else:
			# Stop the animation when idle
			if facing_direction == "right":
				$AnimationPlayer.play("Idle_Right")  # Idle facing right
			else:
				$AnimationPlayer.play("Idle_Left")  # Idle facing left

	# Jumping with the Space bar, play the crouch/jump-start only once
	if Input.is_action_just_pressed("jump") and not is_jumping and not in_air:
		velocity.y = jump_force  # Apply jump force
		is_jumping = true
		in_air = true

		# Play the jump start animation (with crouch) based on facing direction
		if facing_direction == "right":
			$AnimationPlayer.play("Jump_Right")  # Start jump to the right
		elif facing_direction == "left":
			$AnimationPlayer.play("Jump_Left")  # Start jump to the left

	# Handle air movement (once crouch is done, stay in mid-air jump pose)
	if is_jumping:
		if Input.is_action_pressed("ui_right"):  # Move and turn right while in air
			position.x += speed * delta
			facing_direction = "right"  # Change facing direction mid-air
		elif Input.is_action_pressed("ui_left"):  # Move and turn left while in air
			position.x -= speed * delta
			facing_direction = "left"  # Change facing direction mid-air

		velocity.y += gravity * delta  # Apply gravity (fall faster)
		position.y += velocity.y * delta  # Move player up/down

	# Reset jump and return to idle/walk animation when on the ground
	if position.y >= ground_y:
		position.y = ground_y
		velocity.y = 0
		is_jumping = false  # No longer jumping (animation reset)
		in_air = false  # Landed, so no longer in the air
