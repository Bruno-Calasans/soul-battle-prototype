extends CreatureActiveSkill
class_name CreatureUltimateSkill

@export var skillName = 'Slash'

func _ready():
	skill_type = Enum.CREATURE_ATK_TYPE.ULTIMATE


func execute(target: CreatureCard):
	print('Ultimate skill')
