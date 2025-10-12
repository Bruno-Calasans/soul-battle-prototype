extends Effect
class_name StunEffect

func _init(turns: int) -> void:
	base_name = 'Stun'
	type = EFFECT_TYPE.DEBUFF
	set_effect_icon("res://assets/status_effect/stun.png")
	set_total_turns(turns)
	hide_effect_level()
	
	
func apply(target: CreatureCard, origin: CreatureCard = null):
	print('Applying stun')
	target.can_attack = false
	target.can_dodge = false
	

func remove(target: CreatureCard):
	print('Removing stun')
	target.can_attack = true
	target.can_dodge = true
