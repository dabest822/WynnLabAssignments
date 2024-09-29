extends CanvasLayer

var max_health = 5
var current_health = max_health

func take_damage(amount: int):
	current_health -= amount
	if current_health < 0:
		current_health = 0
	
	update_health_ui()

func update_health_ui():
	for i in range(max_health):
		var heart = $HeartContainer.get_child(i)
		if i < current_health:
			heart.visible = true
		else:
			heart.visible = false
