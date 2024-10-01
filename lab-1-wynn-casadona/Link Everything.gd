extends CharacterBody2D

var speed = 200
var run_speed = 400
var jump_force = -600
var gravity = 1200
var facing_direction = "right"
var is_attacking = false
var is_jumping = false
var animation_player: AnimationPlayer

func _ready():
	print("Link script starting...")
	animation_player = find_animation_player(self)
	
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
		# Connect the "animation_finished" signal correctly
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

	if Input.is_action_just_pressed("jump") and is_on_floor() and not is_attacking:
		velocity.y = jump_force
		is_jumping = true

	if Input.is_action_just_pressed("attack") and not is_attacking and not is_jumping:
		is_attacking = true
		# Start attack animation
		play_animation("Attack_" + facing_direction.capitalize())

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		if is_jumping:
			is_jumping = false
		velocity.y = 0

func update_animation():
	if is_attacking:
		return  # Don't change animation if attacking
	
	var anim_to_play = ""
	if is_jumping:
		anim_to_play = "Jump_" + facing_direction.capitalize()
	elif velocity.x != 0:
		anim_to_play = "Run_" + facing_direction.capitalize() if Input.is_key_pressed(KEY_SHIFT) else "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()
	
	play_animation(anim_to_play)

func play_animation(anim_name):
	if animation_player != null:
		if animation_player.has_animation(anim_name):
			if animation_player.current_animation != anim_name:
				animation_player.play(anim_name)
		else:
			print("WARNING: Animation '", anim_name, "' not found!")
	else:
		print("ERROR: Attempted to play animation '", anim_name, "' but AnimationPlayer is null!")

func _on_animation_finished(anim_name):
	if anim_name.begins_with("Attack_"):
		is_attacking = false
