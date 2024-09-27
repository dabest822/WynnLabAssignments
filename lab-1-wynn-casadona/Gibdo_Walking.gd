extends Node2D  # Keep this as Node2D based on your scene structure

var speed = 50
var direction = Vector2.ZERO
var detection_radius = 200
var animation_player: AnimationPlayer
var link: Node2D
var gibdo_body: CharacterBody2D  # This should be your Gibdo's CharacterBody2D

func _ready():
	print("Gibdo script starting...")
	
	# Find the Gibdo CharacterBody2D (assuming it's a sibling or child of this Node2D)
	gibdo_body = $Gibdo  # Adjust this to the correct path of your CharacterBody2D node
	if not gibdo_body:
		print("ERROR: Gibdo CharacterBody2D not found!")
		return

	# Find the AnimationPlayer (assuming it's a child of Gibdo)
	animation_player = $Gibdo/AnimationPlayer  # Adjust to match the path inside your Gibdo
	if animation_player:
		print("AnimationPlayer found at path: ", animation_player.get_path())
	else:
		print("ERROR: AnimationPlayer not found!")

	# Find Link in the scene
	link = get_node("/root/Node2D/Node2D/CollisionShape2D/Link")  # Adjust to the correct path for Link
	if link:
		print("Link found at path: ", link.get_path())
	else:
		print("ERROR: Link not found in the scene!")

func _physics_process(delta):
	if not gibdo_body or not link:
		return

	# Calculate direction to Link
	var to_link = link.global_position - gibdo_body.global_position
	
	if to_link.length() <= detection_radius:
		# Move towards Link
		direction = to_link.normalized()
		gibdo_body.velocity = direction * speed
	else:
		# Stop if Link is out of range
		gibdo_body.velocity = Vector2.ZERO
	
	gibdo_body.move_and_slide()
	
	update_animation()

func update_animation():
	if not animation_player:
		return
	
	if gibdo_body.velocity.length() > 0:
		if gibdo_body.velocity.x > 0:
			animation_player.play("walk_right")
		else:
			animation_player.play("walk_left")
	else:
		# You might want to add idle animations here
		animation_player.stop()
