extends Node2D

@onready var hitbox: HITBOX = $HITBOX # Βρίσκουμε το HITBOX στο δέντρο της σκηνής
@onready var anim: AnimatedSprite2D = $AnimatedSprite2D

var slow = 100
var damage = 0
var slow_origin = "river"


# Called when the node enters the scene tree for the first time.


func _ready() -> void:
	anim.play("flow")
	hitbox.slow = slow
	hitbox.damage = damage
	hitbox.is_damage_zone = false
	hitbox.slow_origin = slow_origin
	
	
	

	
