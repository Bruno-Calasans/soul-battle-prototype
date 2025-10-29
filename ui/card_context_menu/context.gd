extends Node2D
class_name ContextMenu

@onready var popup_menu = $PopupMenu

var position_offset: Vector2 = Vector2(10, 10)
var card: Card

func _ready():
	popup_menu.id_pressed.connect(handle_menu_id_pressed)
	

func set_card(popup_card: Card):
	card = popup_card
	if card is CreatureCard:
		
		if  not card.special_skill:
			popup_menu.remove_item(1)
			popup_menu.reset_size()
			
		elif not card.can_do_special_atk():
			popup_menu.set_item_disabled(1)
			
		if not card.ultimate_skill:
			popup_menu.remove_item(2)
			popup_menu.reset_size()
			
		elif  not card.can_do_ultimate_atk():
			popup_menu.set_item_disabled(2)


func remove_card():
	card = null
	popup_menu.set_item_disabled(1, false)
	popup_menu.set_item_disabled(2, false)
	popup_menu.reset_size()


func show_at_mouse_position():
	var mouse_pos := get_global_mouse_position()
	popup_menu.position = Vector2(mouse_pos.x + position_offset.x, mouse_pos.y + position_offset.y)
	popup_menu.show()


func handle_menu_id_pressed(item_id):
	match item_id:
		0:
			print('Basic attack')
			event_bus.on_creature_attack.emit(card, Enum.CREATURE_ATK_TYPE.BASIC)
			
		1:
			print("Special Attack")
			event_bus.on_creature_attack.emit(card, Enum.CREATURE_ATK_TYPE.SPECIAL)
		2: 
			print('Ultimate attack')
			event_bus.on_creature_attack.emit(card, Enum.CREATURE_ATK_TYPE.ULTIMATE)
		3:
			print('Cancel action')
			event_bus.on_creature_cancel_attack.emit(card, Enum.CREATURE_ATK_TYPE.BASIC)
			remove_card()
