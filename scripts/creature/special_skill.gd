extends CreatureActiveSkill
class_name CreatureSpecialSkill


func _ready():
	skill_type = Enum.CREATURE_ATK_TYPE.SPECIAL


func execute(target: CreatureCard):
	print('Special Skill')
