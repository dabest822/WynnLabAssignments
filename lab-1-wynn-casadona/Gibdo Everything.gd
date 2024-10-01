extends CharacterBody2D

# Gibdo attributes
var speed = 50
var detection_radius = 1000
var gravity = 1200
var attack_range = 30  # Reduced attack range to 30 units
var facing_direction = "right"
var animation_player: AnimationPlayer
var link: Node2D
var is_attacking = false  # Track if Gibdo is attacking

signal gibdo_attack  # Signal for when the Gibdo attacks Link

func _ready():
	print("Gibdo script starting...")
	
	# Assign the AnimationPlayer2 node for Gibdo
	animation_player = get_node("AnimationPlayer2")
	if not animation_player:
		print("ERROR: AnimationPlayer2 not found!")

	# Correct path for Link node
	link = get_node("/root/Node2D/Node2D1/Link")  # Adjusted to match the actual path for Link
	if not link:
		print("ERROR: Link node not found!")

	# Connect Gibdo attack signal to the Link node's damage handler
	if link and link.has_method("_on_gibdo_attack"):
		gibdo_attack.connect(Callable(link, "_on_gibdo_attack"))
	else:
		print("WARNING: Link node does not have an '_on_gibdo_attack' method or couldn't be found.")

func _physics_process(delta):
	if not animation_player:
		print("ERROR: AnimationPlayer2 is missing!")
		return
	if not link:
		print("ERROR: Link node is missing!")
		return
	
	apply_gravity(delta)
	handle_movement_and_attack()
	move_and_slide()
	update_animation()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func handle_movement_and_attack():
	if not link:
		return
	
	# Calculate distance to Link
	var to_link = link.global_position - global_position
	var distance_to_link = to_link.length()
	
	# Update facing direction based on Link's relative position
	if to_link.x > 0:
		facing_direction = "right"
	else:
		facing_direction = "left"
	
	# Check if Gibdo should attack or follow Link
	if distance_to_link <= attack_range:
		is_attacking = true
		velocity.x = 0
		gibdo_attack.emit()  # Emit the attack signal
	else:
		is_attacking = false
		# Move towards Link if within detection radius
		if distance_to_link <= detection_radius:
			velocity.x = sign(to_link.x) * speed
		else:
			velocity.x = 0

func update_animation():
	if not animation_player:
		return
	
	var anim_to_play = ""
	if is_attacking:
		anim_to_play = "Attack_" + facing_direction.capitalize()
	elif abs(velocity.x) > 0:
		anim_to_play = "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()
	
	if animation_player.has_animation(anim_to_play):
		if animation_player.current_animation != anim_to_play or not animation_player.is_playing():
			animation_player.play(anim_to_play)
	else:
		print("WARNING: Animation not found: ", anim_to_play)

func _on_area_2d_body_entered(_body: Node2D) -> void:
	# This function can be used for further interaction, if needed
	pass
