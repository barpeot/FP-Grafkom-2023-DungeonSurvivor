extends Node

const ICON_PATH = "res://Textures/Items/Upgrades/"
const WEAPON_PATH = "res://Textures/Items/Weapons/"
const UPGRADE = {
	"knife1": {
		"icon": WEAPON_PATH + "weapon_knife_icon.png",
		"displayname": "Knife",
		"description": "Throws a knife at a nearby enemy, high damage and attack speed",
		"level": "Level 1",
		"prereq": [],
		"type": "weapon"
	},
	"knife2": {
		"icon": WEAPON_PATH + "weapon_knife_icon.png",
		"displayname": "Knife",
		"description": "Increased damage and speed",
		"level": "Level 2",
		"prereq": ["knife1"],
		"type": "weapon"
	},
	"knife3": {
		"icon": WEAPON_PATH + "weapon_knife_icon.png",
		"displayname": "Knife",
		"description": "Increased projectile number, penetration and speed",
		"level": "Level 3",
		"prereq": ["knife2"],
		"type": "weapon"
	},
	"knife4": {
		"icon": WEAPON_PATH + "weapon_knife_icon.png",
		"displayname": "Knife",
		"description": "Increased projectile, damage, and penetration",
		"level": "Level 4",
		"prereq": ["knife3"],
		"type": "weapon"
	},
	"spear1": {
		"icon": WEAPON_PATH + "weapon_spear_icon.png",
		"displayname": "Spear",
		"description": "A magical spear will follow you attacking enemies in a straight line",
		"level": "Level: 1",
		"prereq": [],
		"type": "weapon"
	},
	"spear2": {
		"icon": WEAPON_PATH + "weapon_spear_icon.png",
		"displayname": "Spear",
		"description": "The spear will now attack an additional enemy per attack",
		"level": "Level: 2",
		"prereq": ["spear1"],
		"type": "weapon"
	},
	"spear3": {
		"icon": WEAPON_PATH + "weapon_spear_icon.png",
		"displayname": "Spear",
		"description": "The spear will attack another additional enemy per attack",
		"level": "Level: 3",
		"prereq": ["spear2"],
		"type": "weapon"
	},
	"spear4": {
		"icon": WEAPON_PATH + "weapon_spear_icon.png",
		"displayname": "Spear",
		"description": "The spear now does + 5 damage per attack and causes 20% additional knockback",
		"level": "Level: 4",
		"prereq": ["spear3"],
		"type": "weapon"
	},
	"tornado1": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"description": "A tornado is created and random heads somewhere in the players direction",
		"level": "Level: 1",
		"prereq": [],
		"type": "weapon"
	},
	"tornado2": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"description": "Tornado is more powerful and An additional Tornado is created",
		"level": "Level: 2",
		"prereq": ["tornado1"],
		"type": "weapon"
	},
	"tornado3": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"description": "Tornado gets more powerful, cooldown reduced",
		"level": "Level: 3",
		"prereq": ["tornado2"],
		"type": "weapon"
	},
	"tornado4": {
		"icon": WEAPON_PATH + "tornado.png",
		"displayname": "Tornado",
		"description": "An additional tornado is created and the tornado gets more powerful",
		"level": "Level: 4",
		"prereq": ["tornado3"],
		"type": "weapon"
	},
	"armor1": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"description": "Reduces Damage By 1 point",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"armor2": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 2",
		"prereq": ["armor1"],
		"type": "upgrade"
	},
	"armor3": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 3",
		"prereq": ["armor2"],
		"type": "upgrade"
	},
	"armor4": {
		"icon": ICON_PATH + "helmet_1.png",
		"displayname": "Armor",
		"description": "Reduces Damage By an additional 1 point",
		"level": "Level: 4",
		"prereq": ["armor3"],
		"type": "upgrade"
	},
	"speed1": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"description": "Movement Speed Increased by 50% of base speed",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"speed2": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"description": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 2",
		"prereq": ["speed1"],
		"type": "upgrade"
	},
	"speed3": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"description": "Movement Speed Increased by an additional 50% of base speed",
		"level": "Level: 3",
		"prereq": ["speed2"],
		"type": "upgrade"
	},
	"speed4": {
		"icon": ICON_PATH + "boots_4_green.png",
		"displayname": "Speed",
		"description": "Movement Speed Increased an additional 50% of base speed",
		"level": "Level: 4",
		"prereq": ["speed3"],
		"type": "upgrade"
	},
	"tome1": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"tome2": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 2",
		"prereq": ["tome1"],
		"type": "upgrade"
	},
	"tome3": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 3",
		"prereq": ["tome2"],
		"type": "upgrade"
	},
	"tome4": {
		"icon": ICON_PATH + "thick_new.png",
		"displayname": "Tome",
		"description": "Increases the size of spells an additional 10% of their base size",
		"level": "Level: 4",
		"prereq": ["tome3"],
		"type": "upgrade"
	},
	"scroll1": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"scroll2": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 2",
		"prereq": ["scroll1"],
		"type": "upgrade"
	},
	"scroll3": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 3",
		"prereq": ["scroll2"],
		"type": "upgrade"
	},
	"scroll4": {
		"icon": ICON_PATH + "scroll_old.png",
		"displayname": "Scroll",
		"description": "Decreases of the cooldown of spells by an additional 5% of their base time",
		"level": "Level: 4",
		"prereq": ["scroll3"],
		"type": "upgrade"
	},
	"ring1": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"description": "Your spells now spawn 1 more additional attack",
		"level": "Level: 1",
		"prereq": [],
		"type": "upgrade"
	},
	"ring2": {
		"icon": ICON_PATH + "urand_mage.png",
		"displayname": "Ring",
		"description": "Your spells now spawn an additional attack",
		"level": "Level: 2",
		"prereq": ["ring1"],
		"type": "upgrade"
	},
	
	"food": {
		"icon": ICON_PATH + "chunk.png",
		"displayname": "Food",
		"description": "Heals 15 HP",
		"level": "N/A",
		"prereq": [],
		"type": "item"
	},
		
}
