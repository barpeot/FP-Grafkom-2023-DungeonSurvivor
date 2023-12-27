extends Area2D

@export var expval = 1

var spr_gem_blue = preload("res://Textures/Coin_Gems/spr_coin_azu.png")
var spr_gem_yellow = preload("res://Textures/Coin_Gems/spr_coin_ama.png")
var spr_gem_red = preload("res://Textures/Coin_Gems/spr_coin_roj.png")

var target = null
var speed = -1

@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var sound = $gem_snd
@onready var anim = $AnimationPlayer

func _ready():
	if expval < 5:
		sprite.texture = spr_gem_blue
		anim.play("idle")
		return
	elif expval < 25:
		sprite.texture = spr_gem_yellow
		anim.play("idle")
		return
	else:
		sprite.texture = spr_gem_red
		anim.play("idle")
		return

func _physics_process(delta):
	if target != null:
		global_position = global_position.move_toward(target.global_position, speed)
		speed += 2*delta

func collection():
	sound.play()
	collision.call_deferred("set", "disabled", true)
	sprite.visible = false
	return expval

func _on_gem_snd_finished():
	queue_free()
