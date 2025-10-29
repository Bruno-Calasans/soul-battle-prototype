extends Node2D
class_name CardDragManager

var screen_size: Vector2
var dragged_card: Card
var default_scale: Vector2
var drag_scale: Vector2
var can_drag: bool = true
var duelist: Duelist

@onready var card_manager: CardManager = $"../CardManager"
@onready var player: Player = $"../Player"
@onready var opponent: Opponent = $"../Opponent"


func _ready() -> void:
	screen_size = get_viewport_rect().size
	default_scale = Vector2(0.8, 0.8)
	drag_scale = default_scale * 1.25
	
	
func _process(delta: float) -> void:
	update_card_position_with_mouse()


func start_drag(card: Card):
	if dragged_card or not can_drag: return
	dragged_card = card
	dragged_card.card_texture.scale = drag_scale


func update_card_position_with_mouse():
	if !dragged_card: return

	var mouse_pos: Vector2 = get_global_mouse_position()
	
	# limit card position on the screen, don't go outside the windows
	var max_x: float = clamp(mouse_pos.x, 0, screen_size.x )
	var max_y: float = clamp(mouse_pos.y, 0, screen_size.y )
	
	dragged_card.position = Vector2(max_x, max_y)


func end_drag():
	if !dragged_card: return
		
	# detect card slots before drop and if the player can summon
	var card_slot = card_manager.get_first_card_slot()
	
	# check duelist
	duelist = card_manager.determines_duelist(dragged_card)
	if dragged_card.duelist_type == Enum.DUELIST_TYPE.PLAYER:
		duelist = player
	else:
		duelist = opponent
	
	# summon card
	if card_slot and card_slot.can_put_this_card(dragged_card, duelist.type) and duelist.can_summon_this_card(dragged_card):
		card_slot.insert_card(dragged_card, duelist.type)
		duelist.hand.remove_card(dragged_card)
		duelist.modify_soul_by(dragged_card.soul_cost)
		
	# card goes back to hand
	else:
		duelist.hand.animate_card_to_position(dragged_card, dragged_card.position_in_hand)
		
	# Set default scale for card texture
	dragged_card.card_texture.scale = default_scale
	dragged_card = null
		

func reset_drag():
	dragged_card.card_texture.scale = default_scale
	dragged_card = null
