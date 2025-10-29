extends Node
class_name TurnManager

var current_turn: int = 1
var first_duelist_to_play: Enum.DUELIST_TYPE

@onready var turn_label: Label = $"../Slots/Buttons/TurnContainer/Value"


func is_player_turn() -> bool:
	var is_even := current_turn % 2 == 0
	if first_duelist_to_play == Enum.DUELIST_TYPE.PLAYER:
		return not is_even
	else:
		return is_even
		
		
func next_turn():
	modify_turn_by(1)


func modify_turn_by(value: int):
	var new_turn_value: int = current_turn + value
	set_turn_value(new_turn_value)
	

func set_turn_value(value: int):
	if turn_label and turn_label.ready:
		current_turn = value
		turn_label.text = str(value)
