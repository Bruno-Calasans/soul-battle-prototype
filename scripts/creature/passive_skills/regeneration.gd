extends Node
class_name RegenerationPassiveSkill

var base_chance: int = 0
var current_chance: int = 0
var regen_value: int = 0


func _init(base_chance: int, current_chance: int, regen_value: int) -> void:
	self.base_chance = base_chance
	self.current_chance = current_chance
	self.regen_value = regen_value
	
	
func modify_regen_value_by(value: int):
	regen_value += max(0, regen_value + value)
	

func modify_current_chance_by(value: int):
	current_chance += max(0, current_chance + value)
	
	
func can_regenerate():
	return Utils.calc_chance(current_chance)
	
	
func execute(target: CreatureCard):
	if can_regenerate():
		target.modify_health_by(regen_value)
	
