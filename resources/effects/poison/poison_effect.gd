extends Effect
class_name PoisonEffect

var status: PoisonStatus = null

var POISON_STATUS_URL = {
	1: "res://resources/effects/poison/status/poison_1.tres",
	2: "res://resources/effects/poison/status/poison_2.tres",
	3: "res://resources/effects/poison/status/poison_3.tres"
}

func _init(level: int, turns: int):
	status = PoisonStatus.new()
	base_name = 'Poison'
	type = EFFECT_TYPE.DEBUFF
	set_effect_icon("res://assets/status_effect/poison.png")
	set_total_turns(turns)
	set_status(level)
	

func set_status(level: int):
	status = load(POISON_STATUS_URL[level])
	set_effect_level(level)
	
	
func apply(target: CreatureCard, origin: CreatureCard = null):
	
	# apply every time
	var poison_dmg = Damage.new(status.dmg_value, status.dmg_type, target, origin)
	target.damage(poison_dmg)
	
	# apply once
	var regeneration = target.status.regeneration
	if regeneration and is_first_time():
		regeneration.modify_all_source_by(-status.decreased_regen_chance)
		
	
func remove(target: CreatureCard):
	target.status.regeneration.modify_all_source_by(status.decreased_regen_chance)
	print('Remove poison')
	
	
