extends Duelist
class_name Player

func _ready() -> void:
	type = Enum.DUELIST_TYPE.PLAYER
	hand.config()
	deck.config()
	set_soul_label(souls)
	set_health_label(health)
