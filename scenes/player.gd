extends Duelist
class_name Player

func _ready() -> void:
	type = Enum.DUELIST_TYPE.PLAYER
	connect_signals()
	hand.config()
	deck.config()
	

func connect_signals():
	if duelist_void.ready:
		event_bus.on_card_destroyed.connect(add_card_to_void)


func add_card_to_void(card: Card):
	duelist_void.add_card(card)
	print('void cards = ', duelist_void.cards)
	
