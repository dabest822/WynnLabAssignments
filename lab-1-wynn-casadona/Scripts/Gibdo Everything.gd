extends CharacterBody2D

var speed = 50
var detection_radius = 1000
var gravity = 1200
var attack_range = 30  # Reduced attack range to 30 units
var facing_direction = "right"
var animation_player: AnimationPlayer
var link: Node2D
var is_attacking = false  # Track if Gibdo is attacking

func _ready():
	print("Gibdo script starting...")
	animation_player = find_animation_player(self)
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
	else:
		print("ERROR: AnimationPlayer not found in the scene tree!")
	link = get_node("/root/Node2D/Node2D1/CollisionShape2D/Link")
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
	var to_link = link.global_position - global_position
	var distance_to_link = to_link.length()
	
	# Always update facing direction based on Link's position
	facing_direction = "right" if to_link.x > 0 else "left"
	
	if distance_to_link <= attack_range:
		# Within attack range
		is_attacking = true
		velocity.x = 0  # Stop moving when attacking
	else:
		# Outside attack range
		is_attacking = false
		if distance_to_link <= detection_radius:
			velocity.x = sign(to_link.x) * speed
		else:
			velocity.x = 0
	
	#print("Distance to Link: ", distance_to_link, " Velocity: ", velocity, " Facing: ", facing_direction, " Attacking: ", is_attacking)
	

func update_animation():
	if not animation_player:
		print("ERROR: Cannot update animation, AnimationPlayer is null!")
		return
	
	var anim_to_play = ""
	if is_attacking:
		anim_to_play = "Attack_" + facing_direction.capitalize()
	elif abs(velocity.x) > 0:
		anim_to_play = "Walk_" + facing_direction.capitalize()
	else:
		anim_to_play = "Idle_" + facing_direction.capitalize()
	
	if animation_player.has_animation(anim_to_play):
		if animation_player.current_animation != anim_to_play:
			animation_player.play(anim_to_play)
			print("Playing animation: ", anim_to_play)
	else:
		print("WARNING: Animation not found: ", anim_to_play)
	
	#print("Current animation: ", animation_player.current_animation)
	#print("Is animation playing: ", animation_player.is_playing())

#This waits until the attack animation finishes and then calls a take damage function.
	
func _on_animation_player_2_animation_finished(anim_name: StringName) -> void:
	print(anim_name)
	if anim_name == "Attack_Left" or anim_name == "Attack_Right":
		print(anim_name)
		
	# typically it's easier to be able to say something like link.take_damage(1). However, since link is actually the sprite2d and the "Node2D1" actually has all the logic attached to itinstead we need to do this:

		$"../Node2D1".take_damage(1)
