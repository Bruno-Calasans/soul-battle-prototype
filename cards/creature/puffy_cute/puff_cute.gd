extends CreatureCard
class_name PuffyCute

func _ready():
	config({
		'name': 'Baiacu Fofinho',
		'desc': 'Passiva: 
	100% resistência a dano de água
	-100% resistência a dano de Eletricidade
	Quando for destruído, a criatura que o destruiu recebe Envenenamento I por 2 turnos',
		'soul_cost': 1,
		'img_url':"res://assets/creature/img/baiacu_fofinho.jpg",
		'base_atk': 1,
		'base_health': 1,
		'base_physical_armor': 0,
		'base_magical_armor': 0,
		'type': CREATURE_TYPE.ANIMAL,
		'race': CREATURE_RACE.FISH,
		'dmg_type': DMG_TYPE.PHYSICAL
	})
	status.dmg_resistence.set_base_resistence(Enum.DMG_TYPE.WATER, 100)
	status.dmg_resistence.set_base_resistence(Enum.DMG_TYPE.ELETRICITY, -100)
	passive_skills = PuffCutePassiveSkill.new()

	
