extends Node
class_name PlayerBattleManager

var attacker_card: Card
var target_card: Card
var attack_type: Enum.CREATURE_ATK_TYPE = Enum.CREATURE_ATK_TYPE.BASIC
var is_attacking: bool = false
var are_player_controllers_disabled: bool = true
var attacking_card_this_turn: Array[Card] = []

@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var drag_manager: CardDragManager = $"../CardDragManager"
@onready var highlight_manager: CardHighlightManager = $"../CardHighlightManager"
@onready var attack_line: AttackLine = $"../AttackLine"
@onready var battle_button: Button = $"../Slots/Buttons/BattlePhaseButton"
@onready var end_turn_button: Button = $"../Slots/Buttons/EndTurnButton"
@onready var battle_manager: BattleManager = $"../BattleManager"
@onready var opponent_manager: OpponentManager = $"../OpponentManager"


func _ready() -> void:
	event_bus.on_creature_attack.connect(on_creature_attack)
	event_bus.on_creature_select_target.connect(on_creature_select_target)
	event_bus.on_creature_cancel_attack.connect(on_creature_cancel_attack)
	

func has_attacked_this_turn(card: Card) -> bool:
	return 	card in attacking_card_this_turn
	

func reset_attacked_cards():
	attacking_card_this_turn.clear()


func reset():
	attacker_card = null	
	target_card = null
	is_attacking = false
	attack_type = Enum.CREATURE_ATK_TYPE.BASIC
	drag_manager.can_drag = true
	highlight_manager.can_highlight = true
	opponent_manager.toggle_opponent_collision(false)
	
	
func toggle_player_collision(value: bool):
	player.deck.deck_collision.disabled = not value
	for card in player.hand.cards:
		card.card_collision.disabled = not value
		

func toggle_player_controllers(value: bool):
	are_player_controllers_disabled = value
	battle_button.disabled = value
	end_turn_button.disabled = value
	

func on_creature_attack(attacker: Card, type: Enum.CREATURE_ATK_TYPE):
	if is_attacking or has_attacked_this_turn(attacker): return
	
	print('Start attack')
	attacker_card = attacker
	attack_type = type
	drag_manager.can_drag = false
	highlight_manager.can_highlight = false
	is_attacking = true
	
	# to detect opponent card with the mouse
	var field_cards = opponent_manager.toggle_opponent_collision(true)
	
	# direct attack opponent
	if field_cards.is_empty():
		await battle_manager.animate_card_direct_atk(attacker, Enum.DUELIST_TYPE.PLAYER)
		opponent.direct_damage(attacker.status.current_atk)
		reset()
		
	# attack card on the field
	else:
		attack_line.start(attacker.position)
	

func on_creature_select_target(target: Card):
	if not is_attacking or has_attacked_this_turn(attacker_card): return
	
	target_card = target
	opponent_manager.toggle_opponent_collision(false)
	
	if attacker_card is CreatureCard:
		attacking_card_this_turn.append(attacker_card)
		attack_line.stop()
		await battle_manager.animate_card_atk(attacker_card, target_card)
		attacker_card.attack(target, attack_type)
		reset()


func on_creature_cancel_attack():
	if not is_attacking: return
	reset()
