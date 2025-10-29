extends Resource
class_name BasicAtkEffectPassiveSkill


var base_chance: int = 20
var current_chance: int = 20
var effect: Effect
var duration: int = 1

func can_apply_effect(target: CreatureCard):
	return target.effects_manager.can_add_effect(effect) and Utils.calc_chance(current_chance)
	
	
func execute(target: CreatureCard):
	if can_apply_effect(target):
		target.effects_manager.add_effect(effect)
