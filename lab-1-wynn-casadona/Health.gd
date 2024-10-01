extends CanvasLayer

# Node References for hearts and animations
@onready var hearts: Array[Sprite2D] = []
@onready var health_ui_animation: AnimationPlayer = $AnimationPlayer3

# Total number of hearts in the UI
@export var max_health: int = 5

func _ready():
	print("Health UI script starting...")
	
	# Dynamically initialize hearts array
	for i in range(1, max_health + 1):
		var heart = get_node_or_null("Heart" + str(i))
		if heart:
			hearts.append(heart)
		else:
			print("WARNING: Heart", i, " not found!")
	
	if hearts.size() != max_health:
		print("ERROR: Not all heart sprites were found. Found ", hearts.size(), " out of ", max_health)
	
	if health_ui_animation:
		print("AnimationPlayer3 found at path: ", health_ui_animation.get_path())
	else:
		print("ERROR: AnimationPlayer3 not found!")
	
	# Initialize health UI
	reset_health_ui()

# Function to update the health UI based on current health value
func update_health_ui(current_health: int):
	print("Updating health UI. Current health: ", current_health)
	
	# Ensure current_health is within bounds
	current_health = clamp(current_health, 0, max_health)
	
	# Update heart visibility
	for i in range(hearts.size()):
		if i < current_health:
			hearts[i].show()
		else:
			hearts[i].hide()
	
	# Trigger losing health animation if applicable
	if health_ui_animation and current_health < max_health:
		var anim_name = "Lose_Heart" + str(max_health - current_health)
		if health_ui_animation.has_animation(anim_name):
			health_ui_animation.play(anim_name)
			print("Playing animation: ", anim_name)
		else:
			print("WARNING: Animation '", anim_name, "' not found!")
	
	# If health is zero, handle game over logic here
	if current_health <= 0:
		print("Game Over")
		# Replace with your game over logic

# Utility function to reset hearts (in case of a new level, revival, etc.)
func reset_health_ui():
	update_health_ui(max_health)
	print("Health UI reset to maximum.")

# Function to be called when player takes damage
func take_damage(amount: int = 1):
	var current_health = get_visible_heart_count() - amount
	update_health_ui(current_health)

# Function to be called when player heals
func heal(amount: int = 1):
	var current_health = get_visible_heart_count() + amount
	update_health_ui(current_health)

# Helper function to count visible hearts
func get_visible_heart_count() -> int:
	return hearts.count(func(heart): return heart.visible)
