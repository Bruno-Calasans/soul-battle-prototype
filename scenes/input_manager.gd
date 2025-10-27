extends Node2D
class_name InputManager

@onready var card_manager: CardManager = $"../CardManager"
@onready var context_menu: ContextMenu = $"../ContextMenu"
@onready var drag_manager: CardDragManager = $"../CardDragManager"
@onready var highlight_manager: CardHighlightManager = $"../CardHighlightManager"

	
func _input(event: InputEvent) -> void:
	
	# when you click and hold left mouse button
	if event and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if  event.is_pressed():
			var first_node = card_manager.get_first_node()
			if not first_node: return
			
			var duelist = card_manager.determines_duelist(first_node)
			if not duelist: return
			
			# get target card
			if first_node is CardArea and not drag_manager.can_drag and not highlight_manager.can_highlight:
				var target_card := card_manager.get_card_on_top()
				event_bus.on_creature_select_target.emit(target_card)
				
			# it fixes the bug where you drag the background card
			# is dragged instead the card where you mouse is hovering on
			elif first_node is CardArea and drag_manager.can_drag:
				var top_card := card_manager.get_card_on_top()
				drag_manager.start_drag(top_card)
		
			# draw after click deck
			elif first_node is DeckArea:
				duelist.deck.turn_draw()
				
		else:
			print('end dragging')
			drag_manager.end_drag()
			

	# context menu
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_RIGHT and event.pressed:
			
		var first_node = card_manager.get_first_node()
		if not first_node: return
		
		var card_slot := first_node.get_parent()
		if not card_slot: return
		
		if card_slot is CardSlot and card_slot.card_in_slot:
			context_menu.set_card(card_slot.card_in_slot)
			context_menu.show_at_mouse_position()
			
			
	# cancel attack
	if event.is_action("cancel_action"):
		drag_manager.can_drag = true
		highlight_manager.can_highlight = true
		event_bus.on_creature_cancel_attack.emit()
	
