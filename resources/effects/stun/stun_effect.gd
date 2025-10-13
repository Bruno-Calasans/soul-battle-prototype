extends Effect
class_name StunEffect


static func create(turns: int):
	var stun_scene: PackedScene = preload("res://resources/effects/stun/stun.tscn")
	var stun: StunEffect = stun_scene.instantiate()
	stun.call_deferred('config', turns)
	return stun
	

func config(turns: int) -> void:
	base_name = 'Stun'
	type = EFFECT_TYPE.DEBUFF
	icon_url = "res://assets/status_effect/stun.png"
	desc = 'Não pode atacar, nem esquivar'
	set_effect_icon(icon_url)
	set_total_turns(turns)
	hide_effect_level()
	config_tooltip(base_name, icon_url, desc, turns)
	
	
func apply(target: CreatureCard, origin: CreatureCard = null):
	print('Applying stun')
	target.can_attack = false
	target.can_dodge = false
	

func remove(target: CreatureCard):
	print('Removing stun')
	target.can_attack = true
	target.can_dodge = true
