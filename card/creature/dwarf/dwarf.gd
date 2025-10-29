extends CreatureCard
class_name Dwarf

func _ready():
	config({
		'name': 'Anão das Caverna Derik',
		'desc': 'Passiva:
-100% de resistência a dano de terra
Tem 10% de refletir 30% dos ataques físicos.

Terremoto (especial): cause 10 de dano de terra e tem 30% de causar Atordoamento.',
		'soul_cost': 1,
		'img_url':"res://assets/creature/img/dwarf.jpeg",
		'base_atk': 3,
		'base_health': 3,
		'base_physical_armor': 3,
		'base_magical_armor': 3,
		'type': CREATURE_TYPE.SKILL,
		'race': CREATURE_RACE.HUMAN,
		'dmg_type': DMG_TYPE.EARTH
	})
	status.dmg_resistence.set_base_resistence(Enum.DMG_TYPE.EARTH, 100)
	special_skill = DwarfSpecialSkill.new()
	passive_skills = DwarfPassiveSkill.new()
