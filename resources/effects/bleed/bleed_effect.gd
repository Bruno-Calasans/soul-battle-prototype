extends Effect
class_name BleedEffect

var status: BleedStatus = null

const BLEED_STATUS_URL = {
	1: "res://resources/effects/bleed/status/bleed_1.tres",
	2: "res://resources/effects/bleed/status/bleed_2.tres",
	3: "res://resources/effects/bleed/status/bleed_3.tres"
}


func _init(level: int, turns: int):
	base_name = 'Bleed'
	type = EFFECT_TYPE.DEBUFF
	set_effect_icon("res://assets/status_effect/bleed.png")
	set_status(2)
	set_status(level)
	set_total_turns(turns)
	
	
	
func set_status(level: int):
	status = load(BLEED_STATUS_URL[level])
	set_effect_level(level)
	
	
func execute(target: CreatureCard, origin: CreatureCard = null):
	print('Applying bleed')
	var dmg = Damage.new(status.dmg_value, status.dmg_type, target, origin)
	target.damage(dmg)
	decrease_turn()
