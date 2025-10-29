extends Node2D
class_name Deck


var cards: Array[Card] = []
var can_draw: bool = true
var draw_this_turn: bool = false
var drawn_card_per_turn: int = 1
var first_turn_drawn_cards = 4


@onready var duelist: Duelist = $".."
@onready var hand: CardHand = $"../Hand"
@onready var card_counter_label: Label = $DeckTexture/CardCounter
@onready var deck_collision: CollisionShape2D = $DeckArea/DeckCollision


func config():
	create_cards_from_data()
	shuffle()
	start_draw()

# draw card on your first turn
func start_draw():
	draw(first_turn_drawn_cards)
	reset_draw()
	
	
# draw card eaach turn
func turn_draw():
	if draw_this_turn: return
	draw(drawn_card_per_turn)
	draw_this_turn = true
	
	
func add_card(card: Card):
	cards.append(card)
	modify_card_counter(1)


func remove_card(card: Card):
	if card in cards:
		cards.erase(card)
		modify_card_counter(-1)


func create_cards_from_data():
	for i in range(duelist.deck_data.size()):
		var card_data: Dictionary = duelist.deck_data[i]
		var card_scene: PackedScene = load(card_data['path'])
		
		for index in range(card_data.amount):
			var card: Card = card_scene.instantiate()
			
			card.position = position
			card.duelist_type = duelist.type
			
			if card and card.card_collision:
				card.card_collision.disabled = true
			add_card(card)
		
		
func shuffle():
	if cards.size() > 1:
		randomize()
		cards.shuffle()
		

func set_card_counter(value: int):
	card_counter_label.text = str(max(0, value))


func modify_card_counter(value: int):
	var current_value = int(card_counter_label.text)
	var new_value = max(0, current_value + value)
	set_card_counter(new_value)


func draw(amount: int = 1) -> bool:
	if not can_draw or cards.size() == 0: return false
	
	# it limites the amount you can draw
	var amount_to_draw = clamp(amount, 1, cards.size())
	
	# add card to hand
	for i in range(amount_to_draw):
		var drawn_card: Card = cards[i]
		hand.add_card(drawn_card)
		if duelist.type == Enum.DUELIST_TYPE.ENEMY:
			drawn_card.card_collision.disabled = true
		else:
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
	
	return true


func reset_draw():
	can_draw = true
	draw_this_turn = false
