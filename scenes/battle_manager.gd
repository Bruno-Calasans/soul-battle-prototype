extends Node
class_name BattleManager

const START_TURN_WAITING_TIME = 1
const END_TURN_WAITING_TIME = 1
const ATTACK_WAITING_TIME = 0.5
const SUMMON_WAITING_TIME = 1
const START_ATK_SPEED = 0.2
const START_ATK_WAITING_TIME = 0.1
const END_ATK_SPEED = 0.1
const END_ATK_WAITING_TIME = 0.1

var current_turn: int = 1
var is_player_controllers_disabled: bool = true
var attacker_card: Card
var target_card: Card
var attack_type: Enum.CREATURE_ATK_TYPE
var is_attacking: bool = false

@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var opponent_slots: OpponentSlots = $"../Slots/OpponentSlots"
@onready var player_slots: PlayerSlots = $"../Slots/PlayerSlots"
@onready var battle_button: Button = $"../Slots/Buttons/BattlePhaseButton"
@onready var end_turn_button: Button = $"../Slots/Buttons/EndTurnButton"
@onready var turn_label: Label = $"../Slots/Buttons/TurnContainer/Value"
@onready var attack_line: AttackLine = $"../AttackLine"
@onready var drag_manager: CardDragManager = $"../CardDragManager"
@onready var highlight_manager: CardHighlightManager = $"../CardHighlightManager"


func _ready() -> void:
	event_bus.on_card_destroyed.connect(card_destroyed_handler)
	event_bus.on_creature_attack.connect(on_creature_attack)
	event_bus.on_creature_select_target.connect(on_creature_selected)
	event_bus.on_creature_cancel_attack.connect(on_cancel_attack)
	

func toggle_player_collision(value: bool):
	player.deck.deck_collision.disabled = not value
	for card in player.hand.cards:
		card.card_collision.disabled = not value
	
	
func toggle_opponent_collision(value: bool) -> Array[Card]:
	var field_cards := opponent_slots.get_all_cards_on_field()
	for card in field_cards:
		card.card_collision.disabled = not value
	return field_cards

	
func on_creature_attack(attacker: Card, type: Enum.CREATURE_ATK_TYPE):
	if is_attacking: return
	
	print('Start attack')
	attacker_card = attacker
	attack_type = type
	drag_manager.can_drag = false
	highlight_manager.can_highlight = false
	is_attacking = true
	
	var field_cards = toggle_opponent_collision(true)
	
	# direct attack opponent
	if field_cards.is_empty():
		await animate_card_direct_atk(attacker, Enum.DUELIST_TYPE.PLAYER)
		opponent.direct_damage(attacker.status.current_atk)
		attacker_card = null
		target_card = null
		drag_manager.can_drag = true
		highlight_manager.can_highlight = true
		is_attacking = false
		
	# attack card on the field
	else:
		attack_line.start(attacker.position)
	

func on_creature_selected(target: Card):
	if not is_attacking: return
	
	print('Select target')
	target_card = target
	toggle_opponent_collision(false)
	
	if attacker_card is CreatureCard:
		attack_line.stop()
		await animate_card_atk(attacker_card, target_card)
		attacker_card.attack(target)
		attacker_card = null
		target_card = null
		drag_manager.can_drag = true
		highlight_manager.can_highlight = true
		is_attacking = false


func on_cancel_attack():
	if is_attacking:
		attacker_card = null
		target_card = null
		drag_manager.can_drag = true
		highlight_manager.can_highlight = true
		is_attacking = false
		toggle_opponent_collision(false)
		
		
func card_destroyed_handler(card: Card):
	if card.duelist_type == Enum.DUELIST_TYPE.PLAYER:
		player.duelist_void.add_card(card)
		player_slots.find_card_slot(card).remove_card()
	else:
		opponent.duelist_void.add_card(card)
		opponent_slots.find_card_slot(card).remove_card()


func choose_card_slot() -> CardSlot:
	# check if there's any creature empty slot
	var empty_slots = opponent_slots.get_front_slots(true)
	
	# ends turn if there's not an empty slot
	if empty_slots.size() == 0:
		return null
		
	# choose a random slot
	var chosed_slot: CardSlot = empty_slots.pick_random()
	return chosed_slot

	
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


func choose_card_from_hand() -> Card:
	var card_hands := opponent.hand.cards
	var best_card: Card
	var best_score := -INF
	
	if card_hands.is_empty():
		return null
	
	for card in card_hands:
		
		if not player.can_summon_this_card(card): continue
		
		var score := get_card_score(card)
		# choose best card
		if score > best_score:
			best_score = score
			best_card = card
		
	return best_card


func choose_target() -> CreatureCard:
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
		

func opponent_attack():
	var creatures := opponent_slots.get_all_summoned_creatures_on_field()
	
	if creatures.is_empty():
		return
		
	await timer(ATTACK_WAITING_TIME)
	for creature in creatures:
		var target = choose_target()
		if target and not target.is_queued_for_deletion():
			await animate_card_atk(creature, target)
			creature.attack(target)
		else:
			await animate_card_direct_atk(creature, Enum.DUELIST_TYPE.ENEMY)
			player.direct_damage(creature.status.current_atk)
				

func animate_to_position(obj: Object, pos: Vector2, speed: float) -> Tween:
	var tween = get_tree().create_tween()
	tween.tween_property(obj, 'position', pos, speed)
	return tween


func animate_card_direct_atk(card: Card, duelist_type: Enum.DUELIST_TYPE):
	var default_pos := card.position
	var default_z_index := card.z_index
	var new_pos_x := default_pos.x
	var new_pos_y: float = -200
	
	if duelist_type ==  Enum.DUELIST_TYPE.ENEMY:
		new_pos_y = 600
		
	# start attack animation
	card.z_index = 5
	var start_atk_pos := Vector2(new_pos_x, new_pos_y)
	animate_to_position(card, start_atk_pos, START_ATK_SPEED)
	await timer(START_ATK_WAITING_TIME)
	
	# end attack animation
	card.z_index = default_z_index
	animate_to_position(card, default_pos, END_ATK_SPEED)
	await timer(END_ATK_WAITING_TIME)
	
	
func animate_card_atk(card: Card, attacked_card: Card):
	var default_pos := card.position
	var default_z_index := card.z_index
	var attacked_card_pos := Vector2(attacked_card.position.x, attacked_card.position.y)
	
	card.z_index = 5
	animate_to_position(card, attacked_card_pos, START_ATK_SPEED)
	await timer(START_ATK_WAITING_TIME)
	
	card.z_index = default_z_index
	animate_to_position(card, default_pos, END_ATK_SPEED)
	await timer(START_ATK_WAITING_TIME)
	
	
func opponent_draw():
	opponent.deck.reset_draw()
	opponent.deck.draw()
	
	
func opponent_summon():
	# summon as many cards are possible
	while(opponent.get_summonable_cards().size() > 0):
		#  choose a card  and slot
		var chosed_slot := choose_card_slot()
		var chosed_card := choose_card_from_hand()

		# summon the card
		if chosed_slot and chosed_card:
			await timer(SUMMON_WAITING_TIME)
			opponent.summon_card(chosed_card, chosed_slot)
			
		
func start_opponent_turn():
	# before start
	next_turn()
	toggle_player_controllers()
	toggle_player_collision(false)
	
	# draws a card
	opponent_draw()
	
	# opponent try to summon a card
	await opponent_summon()
	
	# opponent try to attack
	await opponent_attack()
		

func end_opponent_turn():
	await timer(END_TURN_WAITING_TIME)
	player.deck.reset_draw()
	player.deck.turn_draw()
	toggle_player_controllers()
	toggle_player_collision(true)
	next_turn()
	

func toggle_player_controllers():
	is_player_controllers_disabled = not is_player_controllers_disabled
	battle_button.disabled = not is_player_controllers_disabled
	end_turn_button.disabled = not is_player_controllers_disabled


func next_turn():
	modify_turn_by(1)


func modify_turn_by(value: int):
	var new_turn_value: int = current_turn + value
	set_turn_value(new_turn_value)
	

func set_turn_value(value: int):
	if turn_label and turn_label.ready:
		current_turn = value
		turn_label.text = str(value)


func timer(seconds: float):
	await get_tree().create_timer(seconds).timeout


func _on_battle_phase_button_pressed() -> void:
	pass # Replace with function body.
	

func _on_end_turn_button_pressed() -> void:
	await start_opponent_turn()
	await end_opponent_turn()
