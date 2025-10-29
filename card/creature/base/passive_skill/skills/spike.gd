extends Resource
class_name SpikePassiveSkill


var base_chance: float = 20
var current_chance: float = 20
var spike_perc: float = 50
var dmg_types: Array[Enum.DMG_TYPE] = [Enum.DMG_TYPE.PHYSICAL]
var spike_dmg_type: Enum.DMG_TYPE = Enum.DMG_TYPE.DIRECT


func _init(chance: float, spike_perc: float, dmg_types: Array[Enum.DMG_TYPE], spike_dmg_type: Enum.DMG_TYPE) -> void:
	self.base_chance = chance
	self.current_chance = chance
	self.spike_perc = spike_perc
	self.dmg_types = dmg_types
	self.spike_dmg_type = spike_dmg_type
	

func can_spike(dmg_type: Enum.DMG_TYPE) -> bool:
	return dmg_type in dmg_types and Utils.calc_chance(current_chance)
	
	
func calc_spike_dmg_value(value: int) -> int:
	return ceil(value * (spike_perc / 100))
	
	
func calc_spike_dmg(from_dmg: Damage):
	var spike_dmg = Damage.new(0, spike_dmg_type, from_dmg.origin, from_dmg.target)
	spike_dmg.value = calc_spike_dmg_value(from_dmg.value)
	return spike_dmg
	

func execute(dmg: Damage):
	var attacker = dmg.origin
	var target_spike = dmg.target.passive_skills.spike
	if target_spike and target_spike.can_spike(dmg.type):
		var spike_dmg = target_spike.calc_spike_dmg(dmg)
		print('Spike dmg = ', spike_dmg.value)
		attacker.damage(spike_dmg)
		
