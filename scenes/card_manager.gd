extends Area2D
class_name CardManager

var dragged_card: Card = null
var screen_size: Vector2
var is_hovering_card: bool = false
var default_scale: Vector2
var drag_scale: Vector2
var highlight_scale: Vector2


func _process(delta: float) -> void:
	if dragged_card:
		var texture: TextureRect = dragged_card.card_texture
		var card_size: Vector2 = texture.size
		var mouse_pos: Vector2 = get_global_mouse_position()
		
		# limit card position on the screen, don't go outside the windows
		var max_x: float = clamp(mouse_pos.x, 0, screen_size.x )
		var max_y: float = clamp(mouse_pos.y, 0, screen_size.y )
		
		dragged_card.position = Vector2(max_x, max_y)


func _ready() -> void: 
	screen_size = get_viewport_rect().size
	default_scale = (get_parent() as TextureRect).scale
	drag_scale = default_scale * 1.25
	highlight_scale = default_scale * 1.2


func _input(event: InputEvent) -> void:
	
	# when you click and hold left mouse button
	if event and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		# it fixes the bug where you drag the ackground card
		# is dragged instead the card where you mouse is hovering on
		var card: Card = get_card_on_top()
	
		if  event.is_pressed():
			if card: start_drag(card)
		else:
			end_drag()
	

func start_drag(card: Card):
	if !dragged_card:
		dragged_card = card
		dragged_card.card_texture.scale = drag_scale
	
	
func end_drag():
	if dragged_card:
		
		# detect card slots before drop
		var card_slot = get_first_card_slot()
		if card_slot:
			card_slot.insert_card(dragged_card)
		
		dragged_card.card_texture.scale = default_scale
		dragged_card = null
		
	
func detect_nodes_with_mouse() -> Array:
	var mouse_pos = get_global_mouse_position()
	var space_state = get_world_2d().direct_space_state

	# Cria os parâmetros da consulta
	var params = PhysicsPointQueryParameters2D.new()
	params.position = mouse_pos
	params.collide_with_areas = true
	params.collide_with_bodies = true
	
	# get all the colliders
	var result = space_state.intersect_point(params).map(func(dic): return dic.collider)
	return result


func detect_cards() -> Array[Card]:
	var nodes: Array = detect_nodes_with_mouse()
	var cards: Array[Card] = []
	
	for node in nodes:
		var card = node.get_parent().get_parent()

		if card is Card:
			cards.append(card)
	
	return cards


func detect_card_slots() -> Array[CardSlot]:
	var nodes: Array = detect_nodes_with_mouse()
	var slots: Array[CardSlot] = []
	
	for node in nodes:
		var slot = node.get_parent()
		if slot is CardSlot: slots.append(slot)
	
	return slots


func get_first_card_slot() -> CardSlot:
	var card_slots: Array[CardSlot] = detect_card_slots()
	if card_slots.size() == 0: return null
	return card_slots[0]


func get_card_on_top() -> Card:
	var cards: Array[Card] = detect_cards()
	
	if cards.size() == 0: return null
	
	var top_card: Card = cards[0]
	var highest_z_index: int = top_card.card_texture.z_index
	
	for card in cards:
		if card.card_texture.z_index > highest_z_index:
			top_card = card
			highest_z_index = card.card_texture.z_index
	
	return top_card
	
	
func get_first_card() -> Card:
	var cards: Array[Card] = detect_cards()
	if cards.size() == 0: return null
	return cards[0]


func highlight_card(hovered: bool):
	var card_texture: TextureRect = get_parent()
	
	if hovered:
		card_texture.scale = highlight_scale
		card_texture.z_index = 2
	else:
		card_texture.scale = default_scale
		card_texture.z_index = 1


func _on_mouse_entered() -> void:
	if !is_hovering_card:
		is_hovering_card = true
		highlight_card(true)
		

func _on_mouse_exited() -> void:
	highlight_card(false)
	
	# check if there's any card after hover effect
	var card_after_hover = get_first_card()
	
	# hightlight that card
	if card_after_hover:
		card_after_hover.card_manager.highlight_card(true)
	else:
		is_hovering_card = false
		
	
