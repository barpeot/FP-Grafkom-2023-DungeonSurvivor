extends Area2D

var level = 1
var hp = 9999
var speed = 100.0
var damage = 5
var knockback = 135
var attack_size = 1.0

var last_movement = Vector2.ZERO
var angle = Vector2.ZERO
var angle_less = Vector2.ZERO
var angle_more = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")

signal remove_from_array(object)

func _ready():
	match level:
		1:
			hp = 9999
			speed = 100.0
			damage = 5
			knockback = 135
			attack_size = 1.0 * (1 + player.spell_size)
		2:
			hp = 9999
			speed = 110.0
			damage = 7
			knockback = 140
			attack_size = 1.1 * (1 + player.spell_size)
		3:
			hp = 9999
			speed = 120.0
			damage = 9
			knockback = 145
			attack_size = 1.2 * (1 + player.spell_size)
		4:
			hp = 9999
			speed = 120.0
			damage = 11
			knockback = 150
			attack_size = 1.4 * (1 + player.spell_size)
			
	var move_to_less = Vector2.ZERO
	var move_to_more = Vector2.ZERO
	match last_movement:
		Vector2.UP, Vector2.DOWN:
			move_to_less = global_position + Vector2(randf_range(-1, -0.25), last_movement.y)*500
			move_to_more = global_position + Vector2(randf_range(0.25, 1), last_movement.y)*500
		Vector2.LEFT, Vector2.RIGHT:
			move_to_less = global_position + Vector2(last_movement.x, randf_range(-1, -0.25))*500
			move_to_more = global_position + Vector2(last_movement.x, randf_range(0.25, 1))*500
		Vector2(1,1), Vector2(1,-1), Vector2(-1,-1), Vector2(-1,1):
			move_to_less = global_position + Vector2(last_movement.x, last_movement.y * randf_range(0, 0.75))*500
			move_to_more = global_position + Vector2(last_movement.x * randf_range(0, 0.75), last_movement.y)*500
	
	angle_less = global_position.direction_to(move_to_less)
	angle_more = global_position.direction_to(move_to_more)
	
	var initial_tween = create_tween().set_parallel(true)
	initial_tween.tween_property(self, "scale", Vector2(1,1)*attack_size, 3).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	var final_speed = speed
	speed = speed/5.0
	initial_tween.tween_property(self, "speed", final_speed, 4).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	initial_tween.play()
	
	var tween = create_tween()
	var set_angle = randi_range(0, 1)
	if set_angle == 1:
		angle = angle_less
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
	else:
		angle = angle_more
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
		tween.tween_property(self, "angle", angle_less, 2)
		tween.tween_property(self, "angle", angle_more, 2)
	tween.play()
	
func _physics_process(delta):
	position += angle*speed*delta
	
func enemy_hit(_charge):
	pass


func _on_timer_timeout():
	emit_signal("remove_from_array", self)
	queue_free()
