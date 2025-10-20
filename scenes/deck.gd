extends Control
class_name PlayerDeck

const START_DRAW_CARDS = 4


var deck_data: Array[Dictionary]
var cards: Array[Card] = []
var can_draw: bool = true
var draw_this_turn: bool = false


@onready var hand: PlayerHand = $"../PlayerHand"
@onready var card_counter_label: Label = $DeckTexture/CardCount
@onready var deck_collision: CollisionShape2D = $DeckArea2d/DeckCollision
@onready var player: Player = $"../Player"


func _ready() -> void:
	deck_data = player.deck1
	add_cards()
	shuffle()
	start_draw()


func start_draw():
	# default drawn cards
	for index in range(START_DRAW_CARDS): 
		draw_this_turn = false
		draw(1)
	# you can draw one time this turn
	draw_this_turn = false
	


func add_cards():
	for i in range(deck_data.size()):
		var card_data: Dictionary = deck_data[i]
		var card_scene: PackedScene = load(card_data['path'])
		
		for index in range(card_data.amount):
			var card: Card = card_scene.instantiate()
			card.position = position
			cards.append(card)
			modify_card_counter(1)


func shuffle():
	if cards.size() > 1:
		cards.shuffle()


func set_card_counter(value: int):
	card_counter_label.text = str(max(0, value))


func modify_card_counter(value: int):
	var current_value = int(card_counter_label.text)
	var new_value = max(0, current_value + value)
	set_card_counter(new_value)


func draw(amount: int = 1) -> bool:
	if not can_draw or draw_this_turn: return false
	
	# it limites the amount you can draw
	var amount_to_draw = clamp(amount, 1, cards.size())
	
	# add card to hand
	for i in range(amount_to_draw):
		var drawn_card: Card = cards[i]
		hand.add_card(drawn_card)
		drawn_card.card_animation.play('flip')
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
		
	# you can't draw this turn after manual draw and default draw
	draw_this_turn = true
	
	return true
