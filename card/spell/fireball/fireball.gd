extends SpellCard
class_name FireballSpell


func _ready() -> void:
	set_card_img("res://assets/spell/img/fireball.webp")
	rarity = Enum.CARD_RARITY.COMMON
	set_soul_cost(2)
	
	
