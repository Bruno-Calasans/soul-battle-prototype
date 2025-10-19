extends Node2D
class_name CardHand

const CARD_AMOUNT = 3
const CARD_WIDTH = 130
const HAND_Y_POSITION = 620
const ANIMATION_SPEED = 0.4
const FROM_POSITION  = Vector2(1200, 500)
const START_DRAW_CARDS = 2

var hand: Array[Card] = []
var center_screen_x: float
var card_width: float

@onready var deck: Deck = $"../Deck"


func _ready() -> void:
	center_screen_x = get_viewport_rect().size.x / 2
	if deck.ready:
		deck.draw(START_DRAW_CARDS)
	

func add_card(card: Card):
	# new card to hand
	if card not in hand:
		hand.insert(0, card)
		update_hand_position()
		add_child(card)
		
	# returning card to hand
	else:
		animate_card_to_position(card, card.position_in_hand)
	

func remove_card(card: Card):
	if card in hand:
		hand.erase(card)
		update_hand_position()
		

func update_hand_position():
	for index in range(hand.size()):
		var x_position = calculate_card_position(index)
		var new_position = Vector2(x_position, HAND_Y_POSITION)
		var card: Card = hand.get(index)
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position)
	

func calculate_card_position(index: int) -> float:
	var total_width: float = (hand.size() - 1) * CARD_WIDTH
	var card_x_offset: float = center_screen_x + index * CARD_WIDTH - total_width / 2
	return card_x_offset
	
	
func animate_card_from_position(card: Card, card_position: Vector2):
	var tween_animation = create_tween()
	tween_animation.tween_property(card, 'position', card_position, ANIMATION_SPEED).from(FROM_POSITION)
	
	
func animate_card_to_position(card: Card, card_position: Vector2):
	var tween_animation = create_tween()
	tween_animation.tween_property(card, 'position', card_position, ANIMATION_SPEED)
	

func has_card(card: Card):
	if hand.size() == 0: return false
	return card in hand
