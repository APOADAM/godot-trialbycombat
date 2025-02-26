extends CharacterBody2D

@onready var anim: AnimatedSprite2D = $AnimatedSprite2D
@onready var healthbar = $Healthbar
@onready var hurtbox: hurtbox = $AnimatedSprite2D/hurtbox
@onready var hitbox: HITBOX = $AnimatedSprite2D/HITBOX
@onready var animsplash: AnimatedSprite2D = $AnimatedSprite2D/AnimatedSpritesplash2D
@onready var animslash:AnimatedSprite2D = $AnimatedSprite2D/AnimatedSpriteslash2D

@export var speed: float = 150.0
var base_speed: int = 150
var dir: String = "none"
var is_moving: bool = false
var is_attacking: bool = false
var is_hurt: bool = false
var is_slowed: bool = false
var is_on_water: bool = false
var is_slashing: bool = false
var health: int
var knockback_velocity: Vector2 = Vector2.ZERO
var is_knockback_active: bool = false
var damage = 10
var slow = 0

func _ready() -> void:
	health = 100
	healthbar.init_health(health)
	anim.connect("animation_finished", Callable(self, "_on_animation_finished"))
	$AnimatedSprite2D/HITBOX/buttomhit.disabled = true
	$AnimatedSprite2D/HITBOX/righthit.disabled = true
	$AnimatedSprite2D/HITBOX/lefthit.disabled = true
	$AnimatedSprite2D/HITBOX/uphit.disabled = true
	$AnimatedSprite2D/HITBOX/slashdown.disabled = true
	$AnimatedSprite2D/HITBOX/slashup.disabled = true
	$AnimatedSprite2D/HITBOX/slashleft.disabled = true
	$AnimatedSprite2D/HITBOX/slashright.disabled = true 
	hitbox.damage = damage
	hitbox.slow = slow
	animsplash.visible = false
	add_to_group("Player")
	var node_river = get_node("$../River")
	

func _process(delta: float) -> void:
	if not is_attacking and not is_hurt:
		var input_vec: Vector2 = Input.get_vector("left", "right", "up", "down")
		if input_vec != Vector2.ZERO:
			is_moving = true
			velocity = input_vec * speed
			if abs(input_vec.x) > abs(input_vec.y):
				dir = "left" if input_vec.x < 0 else "right"
			else:
				dir = "up" if input_vec.y < 0 else "down"
		else:
			velocity = Vector2.ZERO
			is_moving = false
		
		move_and_slide()
		
		# Ενημέρωση animations
		if is_moving:
			match dir:
				"left": anim.play("walk_left")
				"right": anim.play("walk_right")
				"up": anim.play("walk_up")
				"down": anim.play("walk_down") 
		else:
			match dir:
				"left": anim.play("idle_left")
				"right": anim.play("idle_right")
				"up": anim.play("idle_up")
				"down": anim.play("idle_down")
	else:
		velocity = Vector2.ZERO
		move_and_slide()
	
	if is_instance_valid(healthbar):
		healthbar.health = health
	
	if Input.is_action_just_pressed("attack") and not is_attacking and not is_hurt:
		attack_anim()
	if Input.is_action_just_pressed("strong_attack") and not is_attacking and not is_hurt:
		slash_anim()

	if is_moving == true and is_on_water ==true:
		animsplash.visible = true
		animsplash.play("splash")
	else:
		animsplash.visible=false
		animsplash.stop()
	dash()
	

func attack_anim():
	is_attacking = true
	match dir:
		"left":
			anim.play("attack_left")
			$AnimatedSprite2D/HITBOX/lefthit.disabled = false
		"right":
			anim.play("attack_right")
			$AnimatedSprite2D/HITBOX/righthit.disabled = false
		"up":
			anim.play("attack_up")
			$AnimatedSprite2D/HITBOX/uphit.disabled = false
		"down":
			anim.play("attack_down")
			$AnimatedSprite2D/HITBOX/buttomhit.disabled = false

func _on_animation_finished():
	var current_anim = anim.animation
	if current_anim.begins_with("attack_"):
		is_attacking = false
	elif current_anim.begins_with("hurt_"):
		is_hurt = false
	
	# Επαναφορά των hitboxes σε disabled
	$AnimatedSprite2D/HITBOX/buttomhit.disabled = true
	$AnimatedSprite2D/HITBOX/righthit.disabled = true
	$AnimatedSprite2D/HITBOX/lefthit.disabled = true
	$AnimatedSprite2D/HITBOX/uphit.disabled = true
	$AnimatedSprite2D/HITBOX/slashdown.disabled = true
	$AnimatedSprite2D/HITBOX/slashup.disabled = true
	$AnimatedSprite2D/HITBOX/slashleft.disabled = true
	$AnimatedSprite2D/HITBOX/slashright.disabled = true 
func take_damage(amount: int, knockback: Vector2 = Vector2.ZERO) -> void:
	if is_hurt:
		return
	is_hurt = true
	health -= amount
	
	apply_knockback(dir, 10.0, 0.5)
	
	if health > 0:
		match dir:
			"left": anim.play("hurt_left")
			"right": anim.play("hurt_right")
			"up": anim.play("hurt_up")
			"down": anim.play("hurt_down")
	else:
		health = 0
		anim.play("dead")
		if not anim.is_connected("animation_finished", Callable(self, "_on_dead_animation_finished")):
			anim.connect("animation_finished", Callable(self, "_on_dead_animation_finished"), CONNECT_ONE_SHOT)

func _on_dead_animation_finished() -> void:
	queue_free()

func apply_knockback(knockback_dir: String, strength: float, duration: float) -> void:
	var knockback_vector := Vector2.ZERO
	match knockback_dir:
		"left":
			knockback_vector = Vector2(1, 0) * strength
		"right":
			knockback_vector = Vector2(-1, 0) * strength
		"up":
			knockback_vector = Vector2(0, 1) * strength
		"down":
			knockback_vector = Vector2(0, -1) * strength

	var target_position = position + knockback_vector
	var collision = move_and_collide(knockback_vector)

	if collision:
		target_position = position

	var tween = create_tween()
	tween.tween_property(self, "position", target_position, duration) \
	.set_trans(Tween.TRANS_SINE) \
	.set_ease(Tween.EASE_OUT)

	

func _on_hurtbox_player_entered_river() -> void:
	is_on_water = true
	speed = speed - 100
	
	

	


func _on_hurtbox_player_exited_river() -> void:
	is_on_water = false
	speed = base_speed
	
	
func dash():
	if Input.is_action_pressed("dash") and (Input.is_action_pressed("left") or Input.is_action_pressed("down") or Input.is_action_pressed("up") or Input.is_action_pressed("right")):
		speed = 800.0
		await get_tree().create_timer(0.1).timeout
		speed = base_speed
		

func slash_anim():
	anim.speed_scale = 0.55
	attack_anim()
	match dir:
		"right":
			$AnimatedSprite2D/HITBOX/slashright.disabled = false
			animslash.flip_h = false
			animslash.rotation_degrees = -308.7
			animslash.position = Vector2(80.516 , 8 )
			animslash.scale = Vector2(0.138 , 0.289)
			
		"left":
			$AnimatedSprite2D/HITBOX/slashleft.disabled = false
			animslash.flip_h = false
			animslash.rotation_degrees = -486.4
			animslash.position = Vector2(-70.194 , 0 )
			animslash.scale = Vector2(0.144 , 0.302)
		"up":
			$AnimatedSprite2D/HITBOX/slashup.disabled = false
			animslash.flip_h = false
			animslash.rotation_degrees = -386
			animslash.position = Vector2(1.032 , -76)
			animslash.scale = Vector2(0.138 , 0.302)
		"down":
			$AnimatedSprite2D/HITBOX/slashdown.disabled = false
			animslash.flip_h = false
			animslash.rotation_degrees = -213
			animslash.position = Vector2(-1.032 , 76)
			animslash.scale = Vector2(0.138 , 0.302)
	await get_tree().create_timer(0.1).timeout
	animslash.play("slash_down")
	await anim.animation_finished
	anim.speed_scale = 1
	
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
