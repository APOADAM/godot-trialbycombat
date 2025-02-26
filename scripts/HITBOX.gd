class_name HITBOX extends Area2D

@export var is_damage_zone : bool = true
@export var damage = 0
@export var slow = 0 
@export var slow_origin : String = "none"



func _init() -> void:
	collision_layer = 2
	collision_mask = 0
