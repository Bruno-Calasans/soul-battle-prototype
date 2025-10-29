extends Duelist
class_name Opponent

func _ready() -> void:
	var viewport_size = get_viewport_rect().size
	
	var deck_pos_x = viewport_size.x - 100
	var deck_pos_y = 80
	var void_pos_x = 57
	var void_pos_y = 100
	
	type = Enum.DUELIST_TYPE.ENEMY
	
	info.position = Vector2(viewport_size.x - 200, viewport_size.y - 100)
	
	hand.HAND_Y_POSITION = 20
	hand.CARD_WIDTH = 80
	hand.invert_add_card_to_hand = false
	
	deck.deck_collision.disabled = true
	deck.position = Vector2(deck_pos_x, deck_pos_y)
	
	duelist_void.position = Vector2(void_pos_x, void_pos_y)
	
	hand.config()
	deck.config()
	
	set_soul_label(souls)
	set_health_label(health)
