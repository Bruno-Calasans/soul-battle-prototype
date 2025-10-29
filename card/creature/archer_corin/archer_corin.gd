extends CreatureCard
class_name ArcherCorin

func _ready():
	config({
		'name': 'Arqueiro Corin',
		'desc': 'Passiva: nenhum
		Flechada Penetrante (especial): Lance uma flecha que causa 6 de dano físico e tem 30% de chance de causar 4 dano perfurante',
		'soul_cost': 1,
		'img_url':"res://assets/creature/img/archer_corin.jpg",
		'base_atk': 3,
		'base_health': 6,
		'base_physical_armor': 3,
		'base_magical_armor': 0,
		'type': CREATURE_TYPE.SKILL,
		'race': CREATURE_RACE.HUMAN,
		'dmg_type': DMG_TYPE.PHYSICAL
	})
	special_skill = ArcherCorinSpecialSkill.new()
