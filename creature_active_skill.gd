extends Resource
class_name CreatureActiveSkill

@export var skill_name: String = 'skill'
@export var skill_type: Enum.CREATURE_ATK_TYPE = Enum.CREATURE_ATK_TYPE.SPECIAL


func _ready():
	print('Special skill is ready')


func execute(target: CreatureCard):
	print('Special Skill')
