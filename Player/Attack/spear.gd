extends Area2D

var level = 1
var hp = 9999
var speed = 250.0
var damage = 8
var knockback = 110
var paths = 2
var attack_size = 1.0
var attack_speed = 3.0

var target = Vector2.ZERO
var target_array = []

var angle = Vector2.ZERO

var resetPosition = Vector2.ZERO

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var sprite = $Sprite2D
@onready var collision = $CollisionShape2D
@onready var attackTimer = get_node("%AttackTimer")
@onready var changeDirectionTimer = get_node("%ChangeDirection")
@onready var resetPosTimer = get_node("%ResetPosTimer")
@onready var spear_snd = $spear_snd

signal remove_from_array(object)

func _ready():
	_on_reset_pos_timer_timeout()
	update_spear()
	
func update_spear():
	level = player.spearlevel
	match level:
		1:
			hp = 9999
			speed = 250.0
			damage = 8
			knockback = 110
			paths = 1
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 3.0 * (1 + player.spell_cooldown)
		2:
			hp = 9999
			speed = 250.0
			damage = 10
			knockback = 110
			paths = 2
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 3.0 * (1 + player.spell_cooldown)
		3:
			hp = 9999
			speed = 250.0
			damage = 12
			knockback = 110
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 3.0 * (1 + player.spell_cooldown)
		4:
			hp = 9999
			speed = 250.0
			damage = 14
			knockback = 120
			paths = 3
			attack_size = 1.0 * (1 + player.spell_size)
			attack_speed = 3.0 * (1 + player.spell_cooldown)
	scale = Vector2(1.0, 1.0)*attack_size
	attackTimer.wait_time = attack_speed
	
func _physics_process(delta):
	if target_array.size() > 0:
		position += angle*speed*delta
	else:
		var player_angle = global_position.direction_to(resetPosition)
		var distance_dif = global_position - player.global_position
		var return_spd = 40.0
		if abs(distance_dif.x) > 500 or abs(distance_dif.y) > 500:
			return_spd = 180.0
		position += player_angle*return_spd*delta
		rotation = global_position.direction_to(player.global_position).angle() + deg_to_rad(135)
	

func add_paths():
	spear_snd.play()
	emit_signal("remove_from_array", self)
	target_array.clear()
	var counter = 0
	while counter < paths:
		var new_path = player.get_random_target()
		target_array.append(new_path)
		counter += 1
		enable_attack(true)
	target = target_array[0]
	process_path()
	
func process_path():
	angle = global_position.direction_to(target)
	changeDirectionTimer.start()
	var tween = create_tween()
	var new_rotation_deg = angle.angle() + deg_to_rad(135)
	tween.tween_property(self, "rotation", new_rotation_deg, 0.25).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_OUT)
	tween.play()

func enable_attack(atk = true):
	if atk:
		collision.call_deferred("set", "disabled", false)
	else:
		collision.call_deferred("set", "disabled", true)

func _on_attack_timer_timeout():
	add_paths()

func _on_change_direction_timeout():
	if target_array.size() > 0:
		target_array.remove_at(0)
		if target_array.size() > 0:
			target = target_array[0]
			process_path()
			spear_snd.play()
			emit_signal("remove_from_array", self)
		else:
			enable_attack(false)
	else:
		changeDirectionTimer.stop()
		attackTimer.start()
		enable_attack(false)


func _on_reset_pos_timer_timeout():
	var choose_direction = randi()%4
	resetPosition = player.global_position
	match choose_direction:
		0:
			resetPosition.x += 80
		1:
			resetPosition.x -= 80
		2:
			resetPosition.y += 80
		3:
			resetPosition.y -= 80
