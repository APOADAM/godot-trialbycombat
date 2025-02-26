extends Node2D
class_name Vase

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $hurtbox/CollisionShape2D

var health: int = 1  # Ένα χτύπημα αρκεί για να σπάσει το vase
func _ready() -> void:
	anim.play("shining")
	
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 0  # Εξασφαλίζουμε ότι δεν πέφτει κάτω από το 0
		anim.play("dead")
	else:
		queue_free()  # Αν δεν υπάρχει break animation, αφαιρούμε το vase αμέσως
		# Απενεργοποιούμε το collision shape για να μην προκύψουν επιπλέον συγκρούσεις
	collision_shape.disabled = true
		# Συνδέουμε το signal animation_finished ώστε, μόλις ολοκληρωθεί το animation, να αφαιρεθεί το vase
	anim.connect("animation_finished", Callable(self, "_on_break_animation_finished"),  CONNECT_ONE_SHOT)

func _on_break_animation_finished() -> void:
	queue_free()
