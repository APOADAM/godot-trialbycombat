class_name hurtbox
extends Area2D

signal player_entered_river
signal player_exited_river
var is_inside: bool = false 
var areaeffect : String = "none"

func _init() -> void:
	collision_layer = 0 
	collision_mask = 2
	
func _ready() -> void:
	# Συνδέουμε τα signals για όταν ένα Area εισέρχεται και εξέρχεται
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("area_exited", Callable(self, "_on_area_exited"))

func _on_area_entered(hitbox: HITBOX) -> void:
	if hitbox == null:
		return
	if hitbox.is_in_group("Player"):
		emit_signal("player_entered_river")
	if hitbox.slow_origin == "river":
		emit_signal("player_entered_river")
	
	# Εφαρμόζουμε ζημιά αν το hitbox προκαλεί damage
	if hitbox.is_damage_zone:
		if owner.has_method("take_damage"): 
			owner.take_damage(hitbox.damage)
	# Εφαρμόζουμε slow αν υπάρχει slow effect
	if hitbox.slow > 0:
		if owner.has_method("apply_slow"):
			owner.apply_slow(hitbox.slow)

func _on_area_exited(hitbox: HITBOX) -> void:
		emit_signal("player_exited_river")
	
