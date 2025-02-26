extends Node2D

@onready var collision_shape: CollisionShape2D = $HITBOX/CollisionShape2D
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: HITBOX = $HITBOX # Βρίσκουμε το HITBOX στο δέντρο της σκηνής

var damage = 5 



# Called when the node enters the scene tree for the first time. 
func _ready() -> void:
	anim.play("campfire")
	hitbox.damage = damage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
