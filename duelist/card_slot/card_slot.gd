extends Control
class_name CardSlot

var card_in_slot: Card
var can_put_card_in_slot: bool = true

@export var slot_variation: Enum.CARD_VARIATION = Enum.CARD_VARIATION.CREATURE
@export var slot_duelist_type: Enum.DUELIST_TYPE = Enum.DUELIST_TYPE.PLAYER

@onready var slot_texture: TextureRect = $Texture
@onready var slot_collision: CollisionShape2D = $Area2D/Collision


func _ready() -> void:
	if slot_duelist_type == Enum.DUELIST_TYPE.ENEMY:
		slot_collision.disabled = true


func can_put_this_card(card: Card, duelist_type: Enum.DUELIST_TYPE) -> bool:
	var has_same_card_variation = card.variation == slot_variation
	var has_same_player_type = slot_duelist_type == duelist_type
	return can_put_card_in_slot and is_empty() and has_same_card_variation and has_same_player_type


func insert_card(card: Card, duelist_type: Enum.DUELIST_TYPE):
	if can_put_this_card(card, duelist_type):
		card_in_slot = card
		can_put_card_in_slot = false
		card.card_collision.disabled = true
		card.position = global_position
	
	
func remove_card():
	if card_in_slot:
		if slot_duelist_type != Enum.DUELIST_TYPE.ENEMY:
			card_in_slot.card_collision.disabled = false
		card_in_slot = null
		can_put_card_in_slot = true
	
	
func is_empty() -> bool:
	return card_in_slot == null
