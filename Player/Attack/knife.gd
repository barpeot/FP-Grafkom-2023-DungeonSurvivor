extends Area2D


var level = 1
var hp = 2
var speed = 100
var damage = 10
var knockback = 100
var attack_size = 1.0

var target = Vector2.DOWN
var angle = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")

signal remove_from_array(object)

func _ready():
	angle = global_position.direction_to(target)
	rotation = angle.angle() + deg_to_rad(135)
	match level:
		1:
			hp = 1
			speed = 100
			damage = 10
			knockback = 100
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 1
			speed = 120
			damage = 16
			knockback = 100
			attack_size = 1.1 * (1 + player.spell_size)
		3:
			hp = 2
			speed = 140
			damage = 18
			knockback = 100
			attack_size = 1.2 * (1 + player.spell_size)
		4:
			hp = 2
			speed = 150
			damage = 20
			knockback = 100
			attack_size = 1.2 * (1 + player.spell_size)
		
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector2(1,1)*attack_size,1).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()
	
func _physics_process(delta):
	position += angle*speed*delta

func enemy_hit(charge = 1):
	hp -= charge
	if hp <= 0:
		emit_signal("remove_from_array", self)
		queue_free()


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
