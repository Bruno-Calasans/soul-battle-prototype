extends Node
class_name BattleManager

const WAITING_TIME_AFTER_END_TURN = 1

var current_turn: int = 1

@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var opponent_slots: OpponentSlots = $"../Slots/OpponentSlots"
@onready var battle_button: Button = $"../Slots/Buttons/BattlePhaseButton"
@onready var end_turn_button: Button = $"../Slots/Buttons/EndTurnButton"


func choose_card_slot() -> CardSlot:
	# check if there's any creature empty slot
	var empty_slots = opponent_slots.get_front_slots(true)
	
	# ends turn if there's not an empty slot
	if empty_slots.size() == 0:
		return null
		
	# choose a random slot
	var chosed_slot: CardSlot = empty_slots.pick_random()
	return chosed_slot
	
	
func choose_card() -> Card:
	var opponent_hand = opponent.hand
	return opponent_hand.hand_cards.pick_random()
	

func start_opponent_turn():
	battle_button.disabled = true
	end_turn_button.disabled = true
	current_turn += 1
	
	# draws a card
	opponent.deck.reset_draw()
	opponent.deck.draw()
	
	# wait a second
	await get_tree().create_timer(WAITING_TIME_AFTER_END_TURN).timeout
	
	
	#  choose a card slot
	var chosed_slot = choose_card_slot()
	if not chosed_slot: 
		end_opponent_turn()
		return
		
	# choose a card
	var chosed_card: Card = choose_card()
	if not chosed_card:
		end_opponent_turn()
		return
	
	# summon the card
	opponent.hand.remove_card(chosed_card)
	chosed_slot.insert_card(chosed_card, Enum.DUELIST_TYPE.ENEMY)
	
	
	# attacks (in development)
	print('chosed card = ', chosed_card)
	print('chosed slot = ', chosed_slot)
	print('card_in_slot = ', chosed_slot.card_in_slot)
	
	print('card position = ', chosed_card.position)
	print('slot position = ', chosed_slot.position)
	
	print('card global position = ', chosed_card.global_position)
	print('slot global position = ', chosed_slot.global_position)
	
	print('card z-index = ', chosed_card.z_index)
	print('card slot z-index = ', chosed_slot.z_index)
	
	# end turn (in development)
	end_opponent_turn()


func end_opponent_turn():
	await get_tree().create_timer(WAITING_TIME_AFTER_END_TURN).timeout
	battle_button.disabled = false
	end_turn_button.disabled = false
	current_turn += 1
	player.deck.reset_draw()


func _on_battle_phase_button_pressed() -> void:
	pass # Replace with function body.
	

func _on_end_turn_button_pressed() -> void:
	start_opponent_turn()
