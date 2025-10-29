extends Resource
class_name RegenHealthPassiveSkill

var regen_value: int = 0


func _init(regen_value: int) -> void:
	self.regen_value = regen_value
	
	
func execute(target: CreatureCard):
		target.regen(Enum.REGEN_SOURCE.CREATURE_PASSIVE, regen_value)
	
