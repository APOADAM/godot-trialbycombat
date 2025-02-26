extends ProgressBar


@onready var damage_bar = $damagebar
@onready var timer = $Timer


var health = 0 : set = _set_health

func _set_health(new_health):
	var prev_health = health
	health = min(max_value , new_health)
	value = health
	if health <= 0:
		queue_free()
	if health < prev_health:
		await get_tree().create_timer(0.5).timeout
		damage_bar.value = health
	
	

func init_health(_health):
	health = _health
	max_value = health
	value = health
	damage_bar.max_value = health
	damage_bar.value = health
