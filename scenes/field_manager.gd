extends Control
class_name FieldManager

var dragged_card: Card = null
var screen_size: Vector2
var is_hovering_card: bool = false
var default_scale: Vector2
var drag_scale: Vector2
var highlight_scale: Vector2

@onready var player: Player = $Player
@onready var hand: PlayerHand = $PlayerHand
@onready var deck: PlayerDeck = $PlayerDeck


func _process(delta: float) -> void:
	update_card_position_with_mouse()


func _ready() -> void: 
	screen_size = get_viewport_rect().size
	default_scale = Vector2(0.8, 0.8)
	drag_scale = default_scale * 1.25
	highlight_scale = default_scale * 1.2
	
	# conect card signals
	event_bus.card_hovered_on.connect(_on_card_hovered_on)
	event_bus.card_hovered_off.connect(_on_card_hovered_off)
	

func _input(event: InputEvent) -> void:
	
	# when you click and hold left mouse button
	if event and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if  event.is_pressed():
			var first_node = get_first_node()
			
			if first_node is CardArea:
				# it fixes the bug where you drag the background card
				# is dragged instead the card where you mouse is hovering on
				start_drag(get_card_on_top())
		
			if first_node is DeckArea:
				deck.draw(1)
		else:
			end_drag()
	

func update_card_position_with_mouse():
	if !dragged_card: return

	var mouse_pos: Vector2 = get_global_mouse_position()
	
	# limit card position on the screen, don't go outside the windows
	var max_x: float = clamp(mouse_pos.x, 0, screen_size.x )
	var max_y: float = clamp(mouse_pos.y, 0, screen_size.y )
	
	dragged_card.position = Vector2(max_x, max_y)


func start_drag(card: Card):
	if dragged_card: return
	dragged_card = card
	dragged_card.card_texture.scale = drag_scale
	
	
func end_drag():
	if !dragged_card: return
		
	# detect card slots before drop and if the player can summon
	var card_slot = get_first_card_slot()
	
	# summon card
	if card_slot and card_slot.can_put_this_card(dragged_card, Enum.PLAYER_TYPE.PLAYER) and player.can_summon_this_card(dragged_card):
		card_slot.insert_card(dragged_card, Enum.PLAYER_TYPE.PLAYER)
		hand.remove_card(dragged_card)
		player.modify_soul_by(dragged_card.soul_cost)
		
	# card goes back to hand
	else:
		hand.animate_card_to_position(dragged_card, dragged_card.position_in_hand)
		
	# Set default scale for card texture
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


func get_first_node() -> Node:
	var nodes = detect_nodes_with_mouse()
	if nodes.size() == 0: return null
	return nodes[0]


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


func highlight_card(card: Card, hovered: bool):
	var card_texture: TextureRect = card.card_texture
	
	if hovered:
		card_texture.scale = highlight_scale
		card_texture.z_index = 2
	else:
		card_texture.scale = default_scale
		card_texture.z_index = 1


func _on_card_hovered_on(card: Card) -> void:
	if is_hovering_card: return
	is_hovering_card = true
	highlight_card(card, true)
		

func _on_card_hovered_off(card: Card) -> void:
	highlight_card(card, false)
	
	# check if there's any card after hover effect
	var card_after_hover = get_first_card()
	
	# hightlight that card (test)
	if card_after_hover and card != card_after_hover:
		highlight_card(card, true)
	else:
		is_hovering_card = false
		
