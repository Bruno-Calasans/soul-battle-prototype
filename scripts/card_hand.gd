extends Node2D
class_name CardHand

var CARD_AMOUNT = 3
var CARD_WIDTH = 100
var HAND_Y_POSITION = 650
var ANIMATION_SPEED = 0.4

var cards: Array[Card] = []
var center_screen_x: float
var invert_add_card_to_hand: bool = false

@onready var duelist: Duelist = $".."


func config():
	center_screen_x = get_viewport_rect().size.x / 2


func add_card(card: Card):
	# new card to hand
	if card not in cards:
		#  insert at the end
		if invert_add_card_to_hand:
			cards.append(card)
		# insert at the start
		else:
			cards.insert(0, card)
		update_hand_position()
		add_child(card)
	# returning card to hand
	else:
		animate_card_to_position(card, card.position_in_hand)
	

func remove_card(card: Card):
	if card in cards:
		cards.erase(card)
		update_hand_position()
		# test
		#remove_child(card)
		

func update_hand_position():
	for index in range(cards.size()):
		var x_position = calculate_card_position(index)
		var new_position = Vector2(x_position, HAND_Y_POSITION)
		var card: Card = cards.get(index)
		card.position_in_hand = new_position
		animate_card_to_position(card, new_position)
	

func calculate_card_position(index: int) -> float:
	var total_width: float = (cards.size() - 1) * CARD_WIDTH
	var card_x_offset: float
	# inverted card order
	if invert_add_card_to_hand:
		card_x_offset = center_screen_x - index * CARD_WIDTH + total_width / 2
	# normal order
	else:
		card_x_offset = center_screen_x + index * CARD_WIDTH - total_width / 2
	return card_x_offset
	
	
func animate_card_from_position(card: Card, card_position: Vector2):
	var tween_animation = create_tween()
	tween_animation.tween_property(card, 'position', card_position, ANIMATION_SPEED)
	
	
func animate_card_to_position(card: Card, card_position: Vector2):
	var tween_animation = create_tween()
	tween_animation.tween_property(card, 'position', card_position, ANIMATION_SPEED)
	

func has_card(card: Card):
	if cards.size() == 0: return false
	return card in cards
