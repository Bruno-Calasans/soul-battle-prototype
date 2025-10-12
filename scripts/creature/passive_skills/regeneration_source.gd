extends Resource
class_name RegenerationSource

const REGEN_SOURCE = Enum.REGEN_SOURCE


var regen_source_chances = {
	REGEN_SOURCE.CREATURE_DMG_RESISTENCE: {
		'base_chance': 100.0,
		'current_chance': 100.0,
	},
	REGEN_SOURCE.CREATURE_PASSIVE: {
		'base_chance': 100.0,
		'current_chance': 100.0,
	},
	REGEN_SOURCE.CREATURE_ACTIVE: {
		'base_chance': 100.0,
		'current_chance': 100.0,
	},
	REGEN_SOURCE.SPELL_EFFECT: {
		'base_chance': 100.0,
		'current_chance': 100.0,
	},
	REGEN_SOURCE.STRUCTURE_EFFECT: {
		'base_chance': 100.0,
		'current_chance': 100.0,
	},
}

func get_source_chance(source: REGEN_SOURCE) -> Dictionary:
	return regen_source_chances[source]


func set_source_chance(source: REGEN_SOURCE, value: float):
	var regen_source = get_source_chance(source)
	regen_source['current_chance'] = max(0, value)


func modify_all_source_by(value: float):
	for source in REGEN_SOURCE:
		var current_chance = get_source_chance(REGEN_SOURCE[source])['current_chance']
		set_source_chance(REGEN_SOURCE[source], value + current_chance)


func set_all_source_chance(value: float):
	for source in REGEN_SOURCE:
		set_source_chance(REGEN_SOURCE[source], value)
	
