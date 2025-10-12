extends CreatureActiveSkill
class_name CreatureUltimateSkill

@export var skillName = 'Slash'

func _ready():
	print('Ultimate skill is ready')

func execute(target: CreatureCard):
	print('Ultimate skill')
