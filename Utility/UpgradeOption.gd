extends ColorRect

var mouse_over = false
var item = null
@onready var player = get_tree().get_first_node_in_group("Player")
@onready var itemName = $ItemName
@onready var itemLv = $ItemLv
@onready var itemDesc = $ItemDesc
@onready var itemIcon = $ItemImg/ItemIcon

signal selected_upgrade(upgrade)

func _ready():
	connect("selected_upgrade", Callable(player, "upgrade_char"))
	if item == null:
		item = "food"
	itemName.text = UpgradeDb.UPGRADE[item]["displayname"]
	itemLv.text = UpgradeDb.UPGRADE[item]["level"]
	itemDesc.text = UpgradeDb.UPGRADE[item]["description"]
	itemIcon.texture = load(UpgradeDb.UPGRADE[item]["icon"])

func _input(event):
	if event.is_action("click"):
		if mouse_over:
			emit_signal("selected_upgrade", item)
			_on_mouse_exited()

func _on_mouse_entered():
	mouse_over = true

func _on_mouse_exited():
	mouse_over = false
