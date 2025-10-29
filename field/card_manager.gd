extends Node2D
class_name CardManager

func determines_duelist(from_node: Node) -> Duelist:
	if !from_node: return null
	
	var is_player: bool = from_node.get_tree().has_group('Player')
	
	if  is_player:
		return $"../Player"
	else: 
		return $"../Opponent"
		

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
