extends Resource
class_name DestructionEffectSkill

var effect: Effect = null

func execute(target: CreatureCard):
	target.effects_manager.add_effect(effect)
	
