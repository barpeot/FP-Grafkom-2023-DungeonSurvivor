extends CharacterBody2D


var movement_speed = 40.0
var hp = 100
var maxhp = 100
var last_movement = Vector2.UP

var experience = 0
var player_level = 1
var collected_exp = 0
var total_experience = 0
var time = 0

# attacks
var knife = preload("res://Player/Attack/knife.tscn")
var tornado = preload("res://Player/Attack/tornado.tscn")
var spear = preload("res://Player/Attack/spear.tscn")

# attack node
@onready var KnifeTimer = get_node("%KnifeTimer")
@onready var KnifeAttackTimer = get_node("%KnifeAttackTimer")
@onready var TornadoTimer = get_node("%TornadoTimer")
@onready var TornadoAttackTimer = get_node("%TornadoAttackTimer")
@onready var spearBase = get_node("%SpearBase")

# Upgrades

var collected_upgrades = []
var available_upgrades = []
var armor = 0
var speed = 0
var spell_cooldown = 0
var spell_size = 0
var amount = 0

# knife
var knife_ammo = 0
var knife_baseammo = 1 
var knife_atkspd = 1.5
var knifelevel = 0

# tornado
var tornado_ammo = 0
var tornado_baseammo = 1 
var tornado_atkspd = 3
var tornadolevel = 0

# spear
var spear_ammo = 1
var spearlevel = 0

# find enemy
var enemy_close = []

@onready var sprite = $Sprite2D
@onready var walkTimer = get_node("%WalkTimer")

#GUI

@onready var exp_bar = get_node("%ExpBar")
@onready var lv_label = get_node("%LvLabel")
@onready var levelup_sc = get_node("%Levelup")
@onready var upgrade_panel = get_node("%Upgrades")
@onready var upgrade_opt = preload("res://Utility/upgrade_option.tscn")
@onready var levelup_snd = get_node("%levelup_snd")
@onready var health_bar = get_node("%HpBar")
@onready var timer_label = get_node("%timerLabel")
@onready var collected_weapons_gui = get_node("%CollectedWeapons")
@onready var collected_upgrades_gui = get_node("%CollectedUpgrades")
@onready var item_container = preload("res://Player/GUI/item_container.tscn")

func _ready():

	attack()
	set_exp_bar(experience, calc_exp_cap())
	_on_hurtbox_hurt(0,0,0)

func _physics_process(delta):
	movement()

func movement():
	var x_mov = Input.get_action_strength("Right") - Input.get_action_strength("Left")
	var y_mov = Input.get_action_strength("Down") - Input.get_action_strength("Up")
	var mov = Vector2(x_mov, y_mov)
	
	if mov.x > 0:
		sprite.flip_h = false
	elif mov.x < 0:
		sprite.flip_h = true
	
	if mov != Vector2.ZERO:
		last_movement = mov
		if walkTimer.is_stopped():
			if sprite.frame >= sprite.hframes - 1:
				sprite.frame = 0
			else:
				sprite.frame += 1
			walkTimer.start()
	
	velocity = mov.normalized()*movement_speed
	move_and_slide()

func attack():
	if knifelevel > 0:
		KnifeTimer.wait_time = knife_atkspd * (1 - spell_cooldown)
		if KnifeTimer.is_stopped():
			KnifeTimer.start()
	
	if tornadolevel > 0:
		TornadoTimer.wait_time = tornado_atkspd * (1 - spell_cooldown)
		if TornadoTimer.is_stopped():
			TornadoTimer.start()
			
	if spearlevel > 0:
		spawn_spear()

func _on_hurtbox_hurt(damage, _angle, _knockback):
	hp -= clamp(damage - armor, 1.0, 999.0)
	health_bar.max_value = maxhp
	health_bar.value = hp

func _on_knife_timer_timeout():
	knife_ammo += knife_baseammo + amount
	KnifeAttackTimer.start()

func _on_knife_attack_timer_timeout():
	if knife_ammo > 0:
		var knife_attack = knife.instantiate()
		knife_attack.position = global_position
		knife_attack.target = get_close_target()
		knife_attack.level = knifelevel
		add_child(knife_attack)
		knife_ammo -= 1
		if knife_ammo > 0:
			KnifeAttackTimer.start()
		else:
			KnifeAttackTimer.stop()
			
func _on_tornado_timer_timeout():
	tornado_ammo += tornado_baseammo + amount
	TornadoAttackTimer.start()

func _on_tornado_attack_timer_timeout():
	if tornado_ammo > 0:
		var tornado_attack = tornado.instantiate()
		tornado_attack.position = global_position
		tornado_attack.last_movement = last_movement
		tornado_attack.level = tornadolevel
		add_child(tornado_attack)
		tornado_ammo -= 1
		if tornado_ammo > 0:
			TornadoAttackTimer.start()
		else:
			TornadoAttackTimer.stop()
		
func spawn_spear():
	var get_spear_total = spearBase.get_child_count()
	var calc_spawns = spear_ammo + amount - get_spear_total
	while calc_spawns > 0:
		var spear_spawn = spear.instantiate()
		spear_spawn.global_position = global_position
		spearBase.add_child(spear_spawn)
		calc_spawns -= 1
	# update when spear is upgraded
	var get_new_spear = spearBase.get_children()
	for i in get_new_spear:
		if i.has_method("update_spear"):
			i.update_spear()

func get_random_target():
	if enemy_close.size() > 0:
		return enemy_close.pick_random().global_position
	else:
		return Vector2.UP

func get_close_target():
	if enemy_close.size() == 0:
		return Vector2.UP
	var closest_distance = INF
	var closest_enemy
	for enemy in enemy_close:
		var distance = (global_position - enemy.global_position).length()
		if distance < closest_distance:
			closest_distance = distance
			closest_enemy = enemy
	return closest_enemy.global_position

func _on_enemy_detection_area_body_entered(body):
	if not enemy_close.has(body):
		enemy_close.append(body)

func _on_enemy_detection_area_body_exited(body):
	if enemy_close.has(body):
		enemy_close.erase(body)


func _on_grab_area_area_entered(area):
	if area.is_in_group("Loot"):
		area.target = self


func _on_collect_area_area_entered(area):
	if area.is_in_group("Loot"):
		var gem_exp = area.collection()
		calc_experience(gem_exp)

func calc_experience(gem):
	var exp_req = calc_exp_cap()
	collected_exp += gem
	if experience + collected_exp >= exp_req: #levelup
		collected_exp -= exp_req-experience
		player_level += 1
		experience = 0
		exp_req = calc_exp_cap()
		levelup()
	else: 
		experience += collected_exp
		collected_exp = 0
	set_exp_bar(experience, exp_req)

func calc_exp_cap():
	var exp_cap = player_level
	if player_level == 1:
		exp_cap = 5
	elif player_level < 21:
		exp_cap = (player_level-1)*5
	elif player_level < 41:
		exp_cap = 90 * (player_level-20)*8
	else:
		exp_cap = 250 + (player_level-40)*12
	return exp_cap
		

func set_exp_bar(set_value = 1, set_max_val = 100):
	exp_bar.value = set_value
	exp_bar.max_value = set_max_val
	
func levelup():
	levelup_snd.play()
	lv_label.text = str("Level ", player_level)
	var tween = levelup_sc.create_tween()
	tween.tween_property(levelup_sc, "position", Vector2(220, 50), 0.5).set_trans(Tween.TRANS_QUINT).set_ease(Tween.EASE_IN)
	tween.play()
	levelup_sc.visible = true
	var options = 0
	var options_max = 3
	while options < options_max:
		var item_opt = upgrade_opt.instantiate()
		if player_level == 2:
			item_opt.item = get_starting_weapon()
		else:
			item_opt.item = get_rand_item()
		upgrade_panel.add_child(item_opt)
		options += 1
	get_tree().paused = true

func upgrade_char(upgrade):
	match upgrade:
		"knife1":
			knifelevel = 1
		"knife2":
			knifelevel = 2
			knife_baseammo += 1
		"knife3":
			knifelevel = 3
			knife_baseammo += 1
		"knife4":
			knifelevel = 4
			knife_baseammo += 2
		"tornado1":
			tornadolevel = 1
		"tornado2":
			tornadolevel = 2
			tornado_baseammo += 1
		"tornado3":
			tornadolevel = 3
			tornado_atkspd -= 0.5
		"tornado4":
			tornadolevel = 4
			tornado_baseammo += 1
		"spear1":
			spearlevel = 1
		"spear2":
			spearlevel = 2
			spear_ammo += 1
		"spear3":
			spearlevel = 3
		"spear4":
			spearlevel = 4
			spear_ammo += 1
		"armor1","armor2","armor3","armor4":
			armor += 1
		"speed1","speed2","speed3","speed4":
			movement_speed += 20.0
		"tome1","tome2","tome3","tome4":
			spell_size += 0.10
		"scroll1","scroll2","scroll3","scroll4":
			spell_cooldown += 0.05
		"ring1","ring2":
			amount += 1
		"food":
			hp += 15
			hp = clamp(hp,0,maxhp)
	
	update_collected_gui(upgrade)
	attack()
	var options = upgrade_panel.get_children()
	for i in options:
		i.queue_free()
	available_upgrades.clear()
	collected_upgrades.append(upgrade)
	levelup_sc.visible = false
	levelup_sc.position = Vector2(800, 44)
	get_tree().paused = false
	calc_experience(0)

func get_rand_item():
	var itemDB = []
	for i in UpgradeDb.UPGRADE:
		if i in collected_upgrades: # upgrade already collected
			pass
		elif i in available_upgrades: # upgrade already an option
			pass
		elif UpgradeDb.UPGRADE[i]["type"] == "item": # dont pick food
			pass
		elif UpgradeDb.UPGRADE[i]["prereq"].size() > 0: # check prereq
			var to_add = true
			for n in UpgradeDb.UPGRADE[i]["prereq"]:
				if not n in collected_upgrades:
					to_add = false
			if to_add:
				itemDB.append(i)
		else:
			itemDB.append(i)
	if itemDB.size() > 0:
		var randomItem = itemDB.pick_random()
		available_upgrades.append(randomItem)
		return randomItem
	else:
		return null
		
func get_starting_weapon():
	var startingWpn = []
	startingWpn.append("knife1")
	startingWpn.append("tornado1")
	startingWpn.append("spear1")
	
	for i in startingWpn:
		if not i in available_upgrades:
			available_upgrades.append(i)
			return i

func change_time(argtime = 0):
	time = argtime
	var get_m = int(time/60.0)
	var get_s = time % 60
	if get_m < 10:
		get_m = str(0, get_m)
	if get_s < 10:
		get_s = str(0, get_s)
	timer_label.text = str(get_m, ":", get_s)

func update_collected_gui(upgrade):
	var get_collection_displayname = UpgradeDb.UPGRADE[upgrade]["displayname"]
	var get_collection_type = UpgradeDb.UPGRADE[upgrade]["type"]
	if get_collection_type != "item":
		var get_collection_displaynames = []
		for i in collected_upgrades:
			get_collection_displaynames.append(UpgradeDb.UPGRADE[i]["displayname"])
		if not get_collection_displayname in get_collection_displaynames:
			var new_item = item_container.instantiate()
			new_item.upgrade = upgrade
			match get_collection_type:
				"weapon":
					collected_weapons_gui.add_child(new_item)
				"upgrade":
					collected_upgrades_gui.add_child(new_item)
