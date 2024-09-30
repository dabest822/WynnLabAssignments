extends CharacterBody2D

var speed = 50
var detection_radius = 1000
var gravity = 1200
var attack_range = 30  # Reduced attack range
var facing_direction = "right"
var animation_player: AnimationPlayer
var link: Node2D
var is_attacking = false
var attack_cooldown = 1.0  # 1 second cooldown between attacks
var attack_timer = 0.0

func _ready():
	print("Gibdo script starting...")
	animation_player = find_animation_player(self)
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
		print("Available animations: ", animation_player.get_animation_list())
	else:
		print("ERROR: AnimationPlayer not found in the scene tree!")
	
	link = get_node("/root/Node2D/Node2D/CollisionShape2D/Link")
	if not link:
		print("ERROR: Link not found in the scene!")

func find_animation_player(node):
	for child in node.get_children():
		if child is AnimationPlayer:
			return child
		var found = find_animation_player(child)
		if found:
			return found
	return null

func _physics_process(delta):
	if not animation_player:
		print("ERROR: AnimationPlayer is still null in _physics_process")
		return
	
	apply_gravity(delta)
	handle_movement_and_attack(delta)
	move_and_slide()
	update_animation()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func handle_movement_and_attack(delta):
	if not link:
		return
	
	# Calculate distance and direction from Gibdo to Link
	var to_link = link.global_position - global_position
	var distance_to_link = to_link.length()
	
	# Update facing direction based on Link's relative position
	facing_direction = "right" if to_link.x > 0 else "left"

	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta

	# Check if Gibdo should attack
	if distance_to_link <= attack_range and attack_timer <= 0:
		is_attacking = true
		attack_timer = attack_cooldown
		velocity = Vector2.ZERO  # Stop movement when attacking
	else:
		is_attacking = false
		# Move towards Link if not in attack range but within detection radius
		if distance_to_link <= detection_radius:
			velocity.x = sign(to_link.x) * speed
		else:
			velocity.x = 0

	print("Distance to Link: ", distance_to_link, " Velocity: ", velocity, " Facing: ", facing_direction, " Attacking: ", is_attacking, " Attack timer: ", attack_timer)

func update_animation():
	if not animation_player:
		print("ERROR: Cannot update animation, AnimationPlayer is null!")
		return
	
	var anim_to_play = ""

	# Determine which animation to play based on Gibdo's state
	if is_attacking and attack_timer > (attack_cooldown - 0.1):  # Ensure attack only starts once per cooldown
		anim_to_play = "Attack_" + facing_direction.capitalize()
	elif abs(velocity.x) > 0:
		anim_to_play = "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()
	
	# Only play animation if it's different from the current one
	if animation_player.has_animation(anim_to_play):
		if animation_player.current_animation != anim_to_play or not animation_player.is_playing():
			animation_player.play(anim_to_play)
			print("Playing new animation: ", anim_to_play)
	else:
		print("WARNING: Animation not found: ", anim_to_play)

	print("Final animation state - Current: ", animation_player.current_animation, " Is playing: ", animation_player.is_playing())
