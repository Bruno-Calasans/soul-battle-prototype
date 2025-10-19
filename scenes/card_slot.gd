extends Node2D
class_name CardSlot

var card_in_slot: Card = null
var can_put_card_in_slot: bool = true
@onready var slot_texture: TextureRect = $Texture


func insert_card(card: Card):
	print('card_in_slot = ', card_in_slot)
	if can_put_card_in_slot and not card_in_slot:
		card_in_slot = card
		can_put_card_in_slot = false
		card.position = position
		card.card_collision.disabled = true
		print(card.position, position)
		
	
func remove_card():
	if card_in_slot:
		card_in_slot.card_collision.disabled = false
		card_in_slot = null
	
