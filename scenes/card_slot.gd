extends Node2D
class_name CardSlot

var card_in_slot: Card = null
var can_put_card_in_slot: bool = true
@onready var slot_texture: TextureRect = $Texture


func insert_card(card: Card):
	print('card_in_slot = ', card)
	if can_put_card_in_slot and not card_in_slot:
		card_in_slot = card
		can_put_card_in_slot = false
		# it dependes on the card type (control, node2d)
		card.position = global_position
		card.card_collision.disabled = true
		
	
func remove_card():
	if card_in_slot:
		card_in_slot.card_collision.disabled = false
		card_in_slot = null
	
