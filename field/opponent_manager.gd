extends Node
class_name OpponentManager

const START_TURN_WAITING_TIME = 1
const END_TURN_WAITING_TIME = 1
const ATTACK_WAITING_TIME = 0.5
const SUMMON_WAITING_TIME = 1
const START_ATK_SPEED = 0.2
const START_ATK_WAITING_TIME = 0.1
const END_ATK_SPEED = 0.1
const END_ATK_WAITING_TIME = 0.1
const ATK_CARD_Z_INDEX = 5

@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var opponent_slots: OpponentSlots = $"../Slots/OpponentSlots"
@onready var player_slots: PlayerSlots = $"../Slots/PlayerSlots"
@onready var battle_manager: BattleManager = $"../BattleManager"
@onready var turn_manager: TurnManager = $"../TurnManager"
@onready var player_battle_manager: PlayerBattleManager = $"../PlayerBattleManager"


func get_card_score(card: Card) -> int:
	var score: int = 0
	
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
			
		
	# spell or structure card
	else:
		print('Choose best spell or structure')
		
	return score


func toggle_opponent_collision(value: bool) -> Array[Card]:
	var field_cards := opponent_slots.get_all_cards_on_field()
	for card in field_cards:
		card.card_collision.disabled = not value
	return field_cards


func opponent_draw():
	opponent.deck.turn_draw()
	

func opponent_choose_card_slot() -> CardSlot:
	# check if there's any creature empty slot
	var empty_slots = opponent_slots.get_front_slots(true)
	
	# ends turn if there's not an empty slot
	if empty_slots.size() == 0:
		return null
		
	# choose a random slot
	var chosed_slot: CardSlot = empty_slots.pick_random()
	return chosed_slot


func opponent_choose_card_from_hand() -> Card:
	var card_hands := opponent.hand.cards
	var best_card: Card
	var best_score := -INF
	
	if card_hands.is_empty():
		return null
	
	for card in card_hands:
		
		if not opponent.can_summon_this_card(card): continue
		
		var score := get_card_score(card)
		# choose best card
		if score > best_score:
			best_score = score
			best_card = card
		
	return best_card


func opponent_choose_target() -> CreatureCard:
	var player_creatures := player_slots.get_all_summoned_creatures_on_field()
	var best_card: CreatureCard
	var best_score := -INF
	
	if player_creatures.is_empty():
		return null
		
	for creature in player_creatures:
		var score := get_card_score(creature)
		if score > best_score:
			best_score = score
			best_card = creature
			
	return best_card
	

func opponent_summon():
	# summon as many cards are possible
	while(opponent.get_summonable_cards().size() > 0):
		#  choose a card  and slot
		var chosed_slot := opponent_choose_card_slot()
		var chosed_card := opponent_choose_card_from_hand()

		# summon the card
		if chosed_slot and chosed_card:
			await battle_manager.timer(SUMMON_WAITING_TIME)
			opponent.summon_card(chosed_card, chosed_slot)
		

func opponent_attack():
	var creatures := opponent_slots.get_all_summoned_creatures_on_field()
	if creatures.is_empty(): return
		
	await battle_manager.timer(ATTACK_WAITING_TIME)
	for creature in creatures:
		var target = opponent_choose_target()
		if target and not target.is_queued_for_deletion():
			await battle_manager.animate_card_atk(creature, target)
			creature.attack(target)
		else:
			await battle_manager.animate_card_direct_atk(creature, Enum.DUELIST_TYPE.ENEMY)
			player.direct_damage(creature.status.current_atk)
	

func start_opponent_turn():
	# before start
	turn_manager.next_turn()
	opponent.regen_soul()
	player_battle_manager.toggle_player_controllers(false)
	player_battle_manager.toggle_player_collision(false)
	
	# draws a card
	opponent_draw()
	
	# opponent try to summon a card
	await opponent_summon()
	
	# opponent try to attack
	await opponent_attack()
		

func end_opponent_turn():
	await battle_manager.timer(END_TURN_WAITING_TIME)
	player.deck.reset_draw()
	player.deck.turn_draw()
	player.regen_soul()
	player_battle_manager.reset_attacked_cards()
	player_battle_manager.toggle_player_controllers(true)
	player_battle_manager.toggle_player_collision(true)
	turn_manager.next_turn()
	
