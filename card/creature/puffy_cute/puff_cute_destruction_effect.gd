extends DestructionEffectSkill
class_name PuffCuteDestructionEffect

func execute(target: CreatureCard):
	var poison := PoisonEffect.create(1, 2)
	target.effects_manager.add_effect(poison)
