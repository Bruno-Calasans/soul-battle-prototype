extends Node2D
class_name Player


var health: int = 100
var souls: int = 2

@onready var soul_label: Label = $Souls

func _ready() -> void:
	set_soul_label(souls)


func can_summon_this_card(card: Card):
	return card.soul_cost <= souls
	
	
func modify_soul_by(amount: int):
	var new_soul_value = max(0, souls - amount) 
	souls = new_soul_value
	set_soul_label(new_soul_value)
	
	
	
func set_soul_label(value: int):
	soul_label.text = str(souls)
	

var deck1: Array[Dictionary] = [{
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
	
