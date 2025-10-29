extends Resource
class_name DodgePassiveSkill

@export var base_chance: int = 0
@export var current_chance: int = 0
@export var atk_types: Array[Enum.CREATURE_ATK_TYPE] = []


func _init(base_chance: int, current_chance: int, atk_types: Array[Enum.CREATURE_ATK_TYPE]):
	self.base_chance = base_chance
	self.current_chance = current_chance
	self.atk_types = atk_types
	
	
func can_dodge(attacker: CreatureCard, atk_type: Enum.CREATURE_ATK_TYPE):
	var basic_atk_ignores = attacker.passive_skills.basic_atk_ignores
	var is_dodge_ignored = basic_atk_ignores and basic_atk_ignores.dodge
	return !is_dodge_ignored and atk_type in atk_types and Utils.calc_chance(current_chance)
	
	
func execute(attacker: CreatureCard, target: CreatureCard, atk_type: Enum.CREATURE_ATK_TYPE) -> bool:
	var target_dodge = target.passive_skills.dodge as DodgePassiveSkill
	if target_dodge and target_dodge.can_dodge(attacker, atk_type) :
		print('Attack was dodge')
		return true
	return false
	
