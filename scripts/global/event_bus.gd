extends Node
class_name EventBus

signal card_hovered_on(card)
signal card_hovered_off(card)
signal duelist_action(duelist: Duelist, action: String)
signal on_card_destroyed(target: Card)
signal on_creature_attack(attacker: Card,type: Enum.CREATURE_ATK_TYPE)
signal on_creature_select_target(target: Card)
signal on_creature_cancel_attack(attacker: Card,type: Enum.CREATURE_ATK_TYPE)
