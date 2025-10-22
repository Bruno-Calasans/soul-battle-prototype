extends Duelist
class_name Opponent

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	var deck_pos_x = viewport_size.x - 100
	var deck_pos_y = 80
	
	type = Enum.DUELIST_TYPE.ENEMY
	
	var info: VBoxContainer = $Info
	info.rotation_degrees = 180
	info.position = Vector2.ONE
	
	hand.HAND_Y_POSITION = 20
	hand.CARD_WIDTH = 80
	hand.invert_add_card_to_hand = false
	
	deck.deck_collision.disabled = true
	deck.position = Vector2(deck_pos_x, deck_pos_y)
	hand.config()
	deck.config()
	
