extends CharacterBody2D

var speed = 50
var detection_radius = 1000
var attack_range = 50
var gravity = 1200
var facing_direction = "right"
var animation_player: AnimationPlayer
var link: Node2D
var ground_y_position: float
var is_attacking = false
var attack_cooldown = 4.0  # Fixed 4-second cooldown
var attack_timer = 0.0

func _ready():
	print("Gibdo script starting...")
	animation_player = find_animation_player(self)
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
	else:
		print("ERROR: AnimationPlayer not found in the scene tree!")
	link = get_node("/root/Node2D/Node2D/CollisionShape2D/Link")
	if link:
		print("Link found at path: ", link.get_path())
	else:
		print("ERROR: Link not found in the scene!")
	
	ground_y_position = global_position.y

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
	handle_movement(delta)
	move_and_slide()
	update_animation()
	print("Gibdo position: ", global_position)  # Debug print

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0
		global_position.y = ground_y_position

func handle_movement(delta):
	if not link:
		print("ERROR: Link not found in handle_movement")
		return

	var to_link = link.global_position - global_position
	to_link.y = 0  # Ignore vertical distance
	var distance_to_link = to_link.length()
	
	print("Distance to Link: ", distance_to_link)  # Debug print

	if distance_to_link <= attack_range:
		if attack_timer <= 0:
			# Attack Link
			is_attacking = true
			attack_timer = attack_cooldown
			print("Gibdo is attacking! Next attack in 4 seconds.")
			velocity.x = 0  # Stop moving while attacking
		else:
			# Cooldown active, don't move
			velocity.x = 0
	elif distance_to_link <= detection_radius:
		# Move towards Link
		var direction = to_link.normalized()
		velocity.x = direction.x * speed
		facing_direction = "right" if velocity.x > 0 else "left"
		is_attacking = false
		print("Moving towards Link. Velocity: ", velocity)  # Debug print
	else:
		velocity.x = 0
		is_attacking = false
	
	# Update attack timer
	if attack_timer > 0:
		attack_timer -= delta

func update_animation():
	var anim_to_play = ""
	if is_attacking:
		anim_to_play = "Attack_" + facing_direction.capitalize()
	elif velocity.x != 0:
		anim_to_play = "Walk_" + facing_direction.capitalize()
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
