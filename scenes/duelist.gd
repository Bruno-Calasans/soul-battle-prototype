extends Node2D
class_name Duelist

var health: int = 100
var souls: int = 2
var type: Enum.DUELIST_TYPE = Enum.DUELIST_TYPE.PLAYER
var deck_data: Array[Dictionary] = [{
		'path': "res://cards/creature/archer_corin/archer_corin.tscn",
		'amount': 2,
	},
	{
		'path': "res://cards/creature/puffy_cute/puff_cute.tscn",
		'amount': 2
	},
	{
		'path': "res://cards/creature/dwarf/dwarf.tscn",
		'amount': 2
	}
]

@onready var soul_label: Label = $Info/Soul/Value
@onready var health_label: Label = $Info/Health/Value
@onready var deck: Deck = $Deck
@onready var hand: CardHand = $Hand


func _ready() -> void:
	set_soul_label(souls)
	set_health_label(health)


func _input(event: InputEvent) -> void:
	# when you click and hold left mouse button
	if event and event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		
		if  event.is_pressed():
			event_bus.duelist_action.emit(self, 'left_mouse_pressed')
		else:
			event_bus.duelist_action.emit(self, 'left_mouse_released')


func can_summon_this_card(card: Card):
	return card.soul_cost <= souls
	

func summon_card(card: Card, slot: CardSlot):
	if not can_summon_this_card(card): return
	
	souls -= card.soul_cost
	hand.remove_card(card)
	slot.insert_card(card, type)

	if type == Enum.DUELIST_TYPE.ENEMY:
		card.card_animation.play('flip_enemy')
	

func modify_soul_by(value: int):
	var new_soul_value = max(0, souls + value) 
	souls = new_soul_value
	set_soul_label(new_soul_value)
	
	
func set_soul_label(value: int):
	if soul_label and soul_label.ready:
		soul_label.text = str(value)
		
		
func set_health_label(value: int):
	if health_label and health_label.ready:
		health_label.text = str(value)	


func modify_health_by(value: int):
	var new_health_value = max(0, health + value) 
	health = new_health_value
	set_health_label(new_health_value)
	
