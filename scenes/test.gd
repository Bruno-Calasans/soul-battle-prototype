extends Node2D
class_name Test

# card 1 to card2
@onready var atk_btn_1: Button = $Buttons/Buttons1/Attack
@onready var special_atk_btn_1: Button = $Buttons/Buttons1/Special
@onready var ultimate_atk_btn_1: Button = $Buttons/Buttons1/Ultimate
@onready var next_turn_btn_1: Button = $Buttons/Buttons1/Next_turn
@onready var heal_card_1: Button = $Buttons/Buttons1/Heal

# card 1 to card2
@onready var atk_btn_2: Button = $Buttons/Buttons2/Attack
@onready var special_atk_btn_2: Button = $Buttons/Buttons2/Special
@onready var ultimate_atk_btn_2: Button = $Buttons/Buttons2/Ultimate
@onready var next_turn_btn_2: Button = $Buttons/Buttons2/Next_turn
@onready var heal_card_2: Button = $Buttons/Buttons2/Heal


@onready var card1 = $CardsContainer/ArcherCorin as CreatureCard
@onready var card2 = $CardsContainer/ArcherCorin2 as CreatureCard
#@onready var card2 = $CardsContainer/PuffCute as CreatureCard
#@onready var card2 = $CardsContainer/Dwarf as CreatureCard


func on_basic_atk_btn_pressed() -> void:
	print(card1.card_name + ' basic attacks ' + card2.card_name)
	card1.attack(card2, Enum.CREATURE_ATK_TYPE.BASIC)


func on_special_atk_btn_pressed() -> void:
	print(card1.card_name + ' special attacks ' + card2.card_name)
	card1.attack(card2, Enum.CREATURE_ATK_TYPE.SPECIAL)
	
	
func on_next_button_btn_pressed() -> void:
	card1.effects_manager.apply_effects()
	card2.effects_manager.apply_effects()


func _on_heal_pressed() -> void:
	card1.regen(Enum.REGEN_SOURCE.CREATURE_ACTIVE, 10)


func _on_attack_pressed_2() -> void:
	print(card2.card_name + ' basic attacks ' + card1.card_name)
	card2.attack(card1, Enum.CREATURE_ATK_TYPE.BASIC)
	

func _on_special_pressed_2() -> void:
	print(card2.card_name + ' special attacks ' + card1.card_name)
	card2.attack(card1, Enum.CREATURE_ATK_TYPE.SPECIAL)
	

func _on_next_turn_pressed_2() -> void:
	card2.effects_manager.apply_effects()
