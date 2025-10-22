extends Node
class_name BattleManager

const WAITING_TIME_AFTER_END_TURN = 1

var current_turn: int = 1

@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var opponent_slots: OpponentSlots = $"../Slots/OpponentSlots"
@onready var battle_button: Button = $"../Slots/Buttons/BattlePhaseButton"
@onready var end_turn_button: Button = $"../Slots/Buttons/EndTurnButton"
@onready var turn_label: Label = $"../Slots/Buttons/TurnContainer/Value"


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
	var best_card: Card
	var best_score: int = -INF
	
	for card in opponent.hand.cards:
		var score: int = 0
		
		# can't summon or active the card
		if card.soul_cost < opponent.souls:
			score -= 1000
			
		
		# best creature card
		if card is CreatureCard:
			var status = card.status
			var passive_skills = card.passive_skills
			
			# resistence score
			for key in status.dmg_resistence.current_resistences.keys():
				score += status.dmg_resistence.current_resistences[key]
				

			# status score
			score += status.current_atk
			score += status.current_health
			score += status.current_physical_armor
			score += status.base_magical_armor
			
			# passive skills score
			if passive_skills:
					
				if passive_skills.dodge:
					score += 60
					
				if passive_skills.passive_regeneration:
					score += 60
					
				if passive_skills.destruction_effect:
					score += 40
					
				if passive_skills.basic_atk_effect:
					score += 100
					
				if passive_skills.basic_atk_ignores:
					score += 50
					
				if passive_skills.spike:
					score += 50
			
			# no passive skills
			else:
				score -= 50
			
			# special skill
			if card.special_skill:
				score += 100
				
			if card.ultimate_skill:
				score += 200
			
		else:
			print('Choose best spell or structure')
			
		print('card name = ', card.card_name)
		print('card score = ', score)
		
		if score > best_score:
			best_score = score
			best_card = card
		
	return best_card

	
func opponent_attack():
	var summoned_creatures := opponent_slots.get_all_summoned_creatures_on_field()
	
	print('turn = ', current_turn)
	for creature in summoned_creatures:
		print(creature.card_name, ' attacks')


func start_opponent_turn():
	battle_button.disabled = true
	end_turn_button.disabled = true
	modify_turn_by(1)
	
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
	opponent.summon_card(chosed_card, chosed_slot)
	
	# attacks (in development)
	opponent_attack()
	
	# end turn (in development)
	end_opponent_turn()


func end_opponent_turn():
	await get_tree().create_timer(WAITING_TIME_AFTER_END_TURN).timeout
	battle_button.disabled = false
	end_turn_button.disabled = false
	player.deck.reset_draw()
	modify_turn_by(1)
	

func modify_turn_by(value: int):
	var new_turn_value: int = current_turn + value
	set_turn_value(new_turn_value)
	

func set_turn_value(value: int):
	if turn_label and turn_label.ready:
		current_turn = value
		turn_label.text = str(value)


func _on_battle_phase_button_pressed() -> void:
	pass # Replace with function body.
	

func _on_end_turn_button_pressed() -> void:
	start_opponent_turn()
