extends Duelist
class_name Player

func _ready() -> void:
	type = Enum.DUELIST_TYPE.PLAYER
	hand.config()
	deck.config()
