extends CharacterBody2D

var speed = 200
var run_speed = 400
var jump_force = -600
var gravity = 1200
var facing_direction = "right"
var is_attacking = false
var is_jumping = false
var animation_player: AnimationPlayer
var jump_animation_played = false

func _ready():
	print("Link script starting...")
	animation_player = find_animation_player(self)
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
		animation_player.connect("animation_finished", Callable(self, "_on_animation_finished"))
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
	handle_input(delta)
	apply_gravity(delta)
	move_and_slide()
	update_animation()

func handle_input(_delta):
	var current_speed = run_speed if Input.is_key_pressed(KEY_SHIFT) else speed

	if not is_attacking:
		velocity.x = 0
		if Input.is_action_pressed("ui_right"):
			velocity.x = current_speed
			facing_direction = "right"
		elif Input.is_action_pressed("ui_left"):
			velocity.x = -current_speed
			facing_direction = "left"

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_jumping:
		velocity.y = jump_force
		is_jumping = true
		jump_animation_played = false
		play_animation("Jump_" + facing_direction.capitalize())

	if Input.is_action_just_pressed("attack") and not is_attacking and is_on_floor():
		is_attacking = true
		play_animation("Hit_" + facing_direction.capitalize())

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if is_jumping:
			is_jumping = false
			jump_animation_played = false

func update_animation():
	if is_attacking:
		return

	var anim_to_play = ""

	if is_jumping:
		if not jump_animation_played:
			anim_to_play = "Jump_" + facing_direction.capitalize()
			jump_animation_played = true
		else:
			return  # Keep last frame of jump animation until landing or switching animation
	elif velocity.x != 0:
		anim_to_play = "Run_" + facing_direction.capitalize() if Input.is_key_pressed(KEY_SHIFT) else "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()

	if anim_to_play != "":
		play_animation(anim_to_play)

func play_animation(anim_name):
	if animation_player != null:
		if animation_player.has_animation(anim_name):
			if animation_player.current_animation != anim_name or not animation_player.is_playing():
				animation_player.play(anim_name)
		else:
			print("WARNING: Animation '", anim_name, "' not found!")
	else:
		print("ERROR: Attempted to play animation '", anim_name, "' but AnimationPlayer is null!")

func _on_animation_finished(anim_name):
	if anim_name.begins_with("Hit_"):
		is_attacking = false
	elif anim_name.begins_with("Jump_"):
		# After jump animation ends, stay in the last frame until new animation is triggered
		if is_on_floor():
			play_animation("Idle_" + facing_direction.capitalize())
