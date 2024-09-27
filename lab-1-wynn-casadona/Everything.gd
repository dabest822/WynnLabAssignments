extends CharacterBody2D

var speed = 200  # Walking speed
var run_speed = 400  # Running speed
var gravity = 1200  # Gravity force to pull the player down
var jump_force = -600  # Jump force to propel the player upwards
var is_jumping = false  # Track if the player is jumping
var is_running = false  # Track if the player is running
var in_air = false  # Track if the character is mid-air
var is_attacking = false  # Track if the player is attacking
var facing_direction = "right"  # Track the player's facing direction

var animation_player: AnimationPlayer

func _ready():
	# Find the AnimationPlayer node
	animation_player = find_animation_player(self)
	if animation_player:
		print("AnimationPlayer found successfully!")
	else:
		print("ERROR: AnimationPlayer not found in the scene tree!")

func find_animation_player(node):
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found = find_animation_player(child)
		if found:
			return found
	return null

func _physics_process(delta):
	apply_gravity(delta)
	handle_movement()
	handle_attack()
	apply_movement()
	update_animation()

func handle_movement():
	is_running = Input.is_action_pressed("run")
	var current_speed
	if is_running:
		current_speed = run_speed
	else:
		current_speed = speed

	# Handle horizontal movement if not attacking
	if not is_attacking:
		if Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
			facing_direction = "right"
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
			facing_direction = "left"
		else:
			velocity.x = 0  # Stop movement when no input

	# Handle jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		in_air = true
		play_animation("Jump_" + facing_direction.capitalize())  # Trigger the jump animation once

func handle_attack():
	# Handle attacking
	if Input.is_action_just_pressed("attack") and not is_attacking:
		is_attacking = true
		play_animation("Hit_" + facing_direction.capitalize())

func apply_gravity(delta):
	# Apply gravity if the player is not on the floor
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		is_jumping = false
		in_air = false
		velocity.y = 0

func apply_movement():
	# Move the player and handle collisions (no arguments required in Godot 4.x)
	move_and_slide()

func update_animation():
	# Handle animations based on state
	if not is_attacking:
		if in_air:
			# Jump animation should only play once when jump starts, not loop
			pass  # No need to play jump again after triggering it in `handle_movement`
		elif velocity.x != 0:
			if is_running:
				play_animation("Run_" + facing_direction.capitalize())
			else:
				play_animation("Walk_" + facing_direction.capitalize())  # Ensure walking works after sprinting
		else:
			play_animation("Idle_" + facing_direction.capitalize())

	# Reset the attack flag once animation finishes
	if is_attacking and animation_player and not animation_player.is_playing():
		is_attacking = false

func play_animation(anim_name):
	# Play the animation if it exists
	if animation_player != null:
		if animation_player.has_animation(anim_name):
			animation_player.play(anim_name)
		else:
			print("WARNING: Animation '", anim_name, "' not found!")
	else:
		print("ERROR: Attempted to play animation '", anim_name, "' but AnimationPlayer is null!")
