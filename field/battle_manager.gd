extends Node
class_name BattleManager

const START_ATK_SPEED = 0.2
const START_ATK_WAITING_TIME = 0.1
const END_ATK_SPEED = 0.1
const END_ATK_WAITING_TIME = 0.1
const ATK_CARD_Z_INDEX = 5


@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"
@onready var opponent_slots: OpponentSlots = $"../Slots/OpponentSlots"
@onready var player_slots: PlayerSlots = $"../Slots/PlayerSlots"
@onready var opponent_manager: OpponentManager = $"../OpponentManager"


func _ready() -> void:
	event_bus.on_card_destroyed.connect(on_card_destroyed)
	

func on_card_destroyed(card: Card):
	if card.duelist_type == Enum.DUELIST_TYPE.PLAYER:
		player.duelist_void.add_card(card)
		player_slots.find_card_slot(card).remove_card()
	else:
		opponent.duelist_void.add_card(card)
		opponent_slots.find_card_slot(card).remove_card()


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
	card.z_index = ATK_CARD_Z_INDEX
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
	
	card.z_index = ATK_CARD_Z_INDEX
	animate_to_position(card, attacked_card_pos, START_ATK_SPEED)
	await timer(START_ATK_WAITING_TIME)
	
	card.z_index = default_z_index
	animate_to_position(card, default_pos, END_ATK_SPEED)
	await timer(START_ATK_WAITING_TIME)
	
	
func timer(seconds: float):
	await get_tree().create_timer(seconds).timeout


func _on_battle_phase_button_pressed() -> void:
	pass # Replace with function body.
	

func _on_end_turn_button_pressed() -> void:
	await opponent_manager.start_opponent_turn()
	await opponent_manager.end_opponent_turn()
