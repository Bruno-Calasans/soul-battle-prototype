extends Node2D
class_name Void

var cards: Array[Card] = []

@export var type: Enum.DUELIST_TYPE = Enum.DUELIST_TYPE.PLAYER
@onready var texture: TextureRect = $Texture
@onready var card_counter: Label = $CardCounter


func set_card_counter(value: int):
	card_counter.text = str(max(0, value))


func modify_card_counter(value: int):
	var current_value = int(card_counter.text)
	var new_value = max(0, current_value + value)
	set_card_counter(new_value)


func add_card(card: Card):
	print('Adding card to void')
	cards.append(card)
	animate_to_void(card)
	modify_card_counter(1)
	
	
func remove_card(card: Card):
	if card in cards:
		cards.erase(card)
		modify_card_counter(-1)
	

func move_to_hand(hand: CardHand, card: Card):
	if card in cards:
		hand.add_card(card)
		remove_card(card)
	
	
func move_to_deck(deck: Deck, card: Card):
	if card in cards:
		deck.add_card(card)
		remove_card(card)

	
func animate_to_void(card: Card):
	var tween := get_tree().create_tween()
	tween.parallel().tween_property(card, 'position', position, 0.2)
	tween.parallel().tween_property(card, 'modulate:a', 0.0, 0.2)
	card.card_animation.play_backwards('flip')
