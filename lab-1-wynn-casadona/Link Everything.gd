extends CharacterBody2D

# Player attributes
var speed = 200  # Walking speed
var run_speed = 400  # Running speed
var gravity = 1200  # Gravity force to pull the player down
var jump_force = -600  # Jump force to propel the player upwards

# State Variables
var is_jumping = false
var is_running = false
var in_air = false
var is_attacking = false
var facing_direction = "right"

# Reference to AnimationPlayer for Link
@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	print("Link script starting...")
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
		# Connect signal for animation completion
		animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
	else:
		print("ERROR: AnimationPlayer not found!")

func _physics_process(delta):
	# Prevent movement during attacks
	if not is_attacking:
		handle_movement(delta)
	apply_gravity(delta)
	apply_movement()

	# Handle attack input separately
	if Input.is_action_just_pressed("attack"):
		handle_attack()

# Handle player movement and jumping
func handle_movement(_delta):
	is_running = Input.is_action_pressed("run")
	var current_speed = run_speed if is_running else speed

	# Reset horizontal velocity
	velocity.x = 0

	# Walk or run left or right
	if Input.is_action_pressed("ui_right"):
		velocity.x = current_speed
		facing_direction = "right"
		if in_air:
			play_animation("Jump_Right")
		else:
			play_animation("Run_Right" if is_running else "Walk_Right")
	elif Input.is_action_pressed("ui_left"):
		velocity.x = -current_speed
		facing_direction = "left"
		if in_air:
			play_animation("Jump_Left")
		else:
			play_animation("Run_Left" if is_running else "Walk_Left")
	else:
		# Play idle animation if not moving
		if not in_air:
			play_animation("Idle_" + facing_direction.capitalize())

	# Jumping
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_force
		is_jumping = true
		in_air = true
		play_animation("Jump_" + facing_direction.capitalize())

# Apply gravity while not on the ground
func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
		in_air = true
	else:
		if is_jumping:
			is_jumping = false
		in_air = false
		velocity.y = 0

# Apply movement based on velocity
func apply_movement():
	move_and_slide()

# Handle attack input
func handle_attack():
	if not is_attacking:
		is_attacking = true
		play_animation("Attack_" + facing_direction.capitalize())

# Play a specific animation if it exists
func play_animation(anim_name: String):
	if animation_player and animation_player.has_animation(anim_name):
		if not animation_player.is_playing() or animation_player.current_animation != anim_name:
			animation_player.play(anim_name)
	else:
		print("WARNING: Animation '%s' not found in AnimationPlayer!" % anim_name)

# Handle animation completion
func _on_animation_finished(anim_name: String):
	if anim_name.begins_with("Attack_"):
		is_attacking = false
	elif anim_name.begins_with("Jump_") and not in_air:
		# Transition to idle or walk animation after landing
		if velocity.x != 0:
			play_animation("Walk_" + facing_direction.capitalize())
		else:
			play_animation("Idle_" + facing_direction.capitalize())

# Function to handle Link getting attacked by Gibdo
func _on_gibdo_attack():
	print("Link was attacked by Gibdo.")
	# Add damage handling logic here if needed in the future
