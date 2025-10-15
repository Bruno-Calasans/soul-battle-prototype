extends Resource
class_name DmgResistence

const DMG_TYPE = Enum.DMG_TYPE

var base_resistences: Dictionary[DMG_TYPE, int] = {
	DMG_TYPE.PHYSICAL: 0,
	DMG_TYPE.EARTH: 0,
	DMG_TYPE.WIND: 0,
	DMG_TYPE.FIRE: 0,
	DMG_TYPE.WATER: 0,
	DMG_TYPE.COLD: 0,
	DMG_TYPE.LIGHT: 0,
	DMG_TYPE.DARK: 0,
	DMG_TYPE.ELETRICITY: 0,
}

var current_resistences: Dictionary[DMG_TYPE, int] = {
	DMG_TYPE.PHYSICAL: 0,
	DMG_TYPE.EARTH: 0,
	DMG_TYPE.WIND: 0,
	DMG_TYPE.FIRE: 0,
	DMG_TYPE.WATER: 0,
	DMG_TYPE.COLD: 0,
	DMG_TYPE.LIGHT: 0,
	DMG_TYPE.DARK: 0,
	DMG_TYPE.ELETRICITY: 0,
}

func set_base_resistence(type: DMG_TYPE, value: int):
	base_resistences.set(type, value)
	current_resistences.set(type, value)
	
	
func set_current_resistence(type: DMG_TYPE, value: int):
	current_resistences.set(type, value)
	

func get_resistence(type: DMG_TYPE):	
	if type in base_resistences: 
		return current_resistences[type]
	return 0
	
	
func apply_dmg_resistence(dmg: Damage):
	var resistence = get_resistence(dmg.type)
	if resistence == 0: 
		print('Creature has not damage resistence to this type of damage')
		return
	
	# decreases damage (positive resistence)
	if resistence > 0 and resistence <= 100:
		var dmg_multiplier = resistence / 100
		var reduced_dmg_value = round(dmg.value * dmg_multiplier)
		dmg.value = max(1, dmg.value - reduced_dmg_value)
		print('Decreases damage = '  + str(reduced_dmg_value))
	
	# cure target
	if resistence > 100:
		var health_multiplier = resistence / 100
		var extra_health = round(dmg.value * health_multiplier)
		dmg.target.regen(Enum.REGEN_SOURCE.CREATURE_PASSIVE, extra_health)
		print('Heal from damage')
		
	# increases damage (negative resistence)
	if resistence < 0:
		var dmg_multiplier: float = abs(resistence) / 100
		var increased_dmg_value: int = round(dmg.value * dmg_multiplier)
		dmg.value = max(1, dmg.value + increased_dmg_value)
		print('Increases damage = ' + str(increased_dmg_value))
	
