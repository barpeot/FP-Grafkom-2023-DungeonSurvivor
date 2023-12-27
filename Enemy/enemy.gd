extends CharacterBody2D

@export var movement_speed = 20.0
@export var hp = 10
@export var knockback_res = 3.5
@export var expval = 1
@export var enemy_damage = 1
var knockback = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var loot_base = get_tree().get_first_node_in_group("Loot")
@onready var sprite = $Sprite2D
@onready var anim = $AnimationPlayer
@onready var hit_sound = $hit_sound
@onready var hitbox = $Hitbox

var exp_gem = preload("res://Objects/gem.tscn")
var death_anim = preload("res://Enemy/explosion.tscn")

signal remove_from_array(object)

func _ready():
	anim.play("Walk")
	hitbox.damage = enemy_damage

func _physics_process(_delta):
	knockback = knockback.move_toward(Vector2.ZERO, knockback_res)
	var direction = global_position.direction_to(player.global_position)
	velocity = direction*movement_speed
	velocity += knockback
	move_and_slide()
	
	if direction.x > 0.1:
		sprite.flip_h = false
	elif direction.x < -0.1:
		sprite.flip_h = true

func death():
	emit_signal("remove_from_array", self)
	var enemy_death = death_anim.instantiate()
	enemy_death.scale = sprite.scale*0.7
	enemy_death.global_position = global_position
	get_parent().call_deferred("add_child", enemy_death)
	var new_gem = exp_gem.instantiate()
	new_gem.global_position = global_position
	new_gem.expval = expval
	loot_base.call_deferred("add_child", new_gem)
	queue_free()

func _on_hurtbox_hurt(damage, angle, knockback_amount):
	hp -= damage
	knockback = angle*knockback_amount
	if hp <= 0:
		death()
	else:
		hit_sound.play()
