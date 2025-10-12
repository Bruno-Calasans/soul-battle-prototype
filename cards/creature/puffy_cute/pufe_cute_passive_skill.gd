extends CreaturePassiveSkill
class_name PuffCutePassiveSkill

func _init():
	destruction_effect = DestructionEffectSkill.new()
	destruction_effect.effect = PoisonEffect.new(1, 3)
	print(destruction_effect.effect.base_name)
