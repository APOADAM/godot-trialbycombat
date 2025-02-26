extends CharacterBody2D
@onready var anim : AnimatedSprite2D = $AnimatedSprite2D
@onready var hurtbox: hurtbox = $AnimatedSprite2D/hurtbox
@onready var healthbar = $Healthbar
var is_hurt :bool = false


var health = 100
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("dummy")
	healthbar.init_health(health)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	
	if is_instance_valid(healthbar):
		healthbar.health = health
		
		
		
func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		health = 100
	
	
