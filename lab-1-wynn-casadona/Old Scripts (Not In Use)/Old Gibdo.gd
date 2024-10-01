extends CharacterBody2D

var speed = 50
var detection_radius = 1000
var gravity = 1200
var attack_range = 30
var facing_direction = "right"
var animation_player: AnimationPlayer
var link: Node2D
var is_attacking = false
var attack_cooldown = 1.0
var attack_timer = 0.0
var attack_duration = 0.5  # Duration of the attack animation

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
	
	var to_link = link.global_position - global_position
	var distance_to_link = to_link.length()
	
	facing_direction = "right" if to_link.x > 0 else "left"
	
	if attack_timer > 0:
		attack_timer -= delta
	
	if distance_to_link <= attack_range and attack_timer <= 0:
		is_attacking = true
		attack_timer = attack_cooldown
		velocity = Vector2.ZERO
	elif is_attacking and attack_timer > attack_cooldown - attack_duration:
		# Keep the Gibdo stationary during the attack animation
		velocity = Vector2.ZERO
	else:
		is_attacking = false
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
	if is_attacking and attack_timer > attack_cooldown - attack_duration:
		anim_to_play = "Attack_" + facing_direction.capitalize()
	elif abs(velocity.x) > 0:
		anim_to_play = "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()
	
	if animation_player.has_animation(anim_to_play):
		if animation_player.current_animation != anim_to_play or not animation_player.is_playing():
			if anim_to_play.begins_with("Attack"):
				# For attack animations, we'll use custom_speed to slow down the animation
				animation_player.play(anim_to_play, -1, 1.0 / attack_duration)
			else:
				# For other animations, play at normal speed
				animation_player.play(anim_to_play)
			print("Playing new animation: ", anim_to_play)
	else:
		print("WARNING: Animation not found: ", anim_to_play)
	
	print("Final animation state - Current: ", animation_player.current_animation, " Is playing: ", animation_player.is_playing())
