extends Node2D
class_name Deck

var deck_data: Array[Dictionary]
var cards: Array[Card] = []
var can_draw: bool = true

@onready var hand: CardHand = $"../Hand"
@onready var card_counter_label: Label = $DeckTexture/CardCount
@onready var deck_collision: CollisionShape2D = $DeckArea2d/DeckCollision
@onready var player: Player = $"../Player"


func _ready() -> void:
	deck_data = player.deck1
	add_cards_to_deck()
	shuffle_deck()


func add_cards_to_deck():
	for i in range(deck_data.size()):
		var card_data: Dictionary = deck_data[i]
		var card_scene: PackedScene = load(card_data['path'])
		
		for index in range(card_data.amount):
			var card: Card = card_scene.instantiate()
			card.position = position
			cards.append(card)
			modify_card_counter(1)


func shuffle_deck():
	if cards.size() > 1:
		cards.shuffle()


func set_card_counter(value: int):
	card_counter_label.text = str(max(0, value))


func modify_card_counter(value: int):
	var current_value = int(card_counter_label.text)
	card_counter_label.text = str(max(0, current_value + value))


func draw(amount: int = 1) -> bool:
	if not can_draw: return false
	
	# it limites the amount you can draw
	var amount_to_draw = clamp(amount, 1, cards.size())
	
	# add card to hand
	for i in range(amount_to_draw):
		var drawn_card: Card = cards[i]
		hand.add_card(drawn_card)
		modify_card_counter(-1)
		
	# remove from deck
	for i in range(amount_to_draw):
		cards.pop_front()
		
	# disable deck
	if cards.size() == 0:
		deck_collision.disabled = true
		card_counter_label.visible = false
		#visible = false
		can_draw = false
		
	return true
