extends Control
class_name CardSlot

var card_in_slot: Card = null
var can_put_card_in_slot: bool = true

@export var slot_variation: Enum.CARD_VARIATION = Enum.CARD_VARIATION.CREATURE
@export var slot_player_type: Enum.DUELIST_TYPE = Enum.DUELIST_TYPE.PLAYER

@onready var slot_texture: TextureRect = $Texture
@onready var slot_collision: CollisionShape2D = $Area2D/Collision


func _ready() -> void:
	if slot_player_type == Enum.DUELIST_TYPE.ENEMY:
		slot_collision.disabled = true


func can_put_this_card(card: Card, player_type: Enum.DUELIST_TYPE) -> bool:
	var has_same_card_variation = card.variation == slot_variation
	var has_same_player_type = slot_player_type == player_type
	return can_put_card_in_slot and not card_in_slot and has_same_card_variation and has_same_player_type


func insert_card(card: Card, player_type: Enum.DUELIST_TYPE):
	if can_put_this_card(card, player_type):
		card_in_slot = card
		can_put_card_in_slot = false
		# it dependes on the card type (control, node2d)
		card.position = global_position
		card.card_collision.disabled = true
		
	
func remove_card():
	if card_in_slot:
		card_in_slot.card_collision.disabled = false
		card_in_slot = null
	
