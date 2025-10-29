extends CreatureSpecialSkill
class_name ArcherCorinSpecialSkill

func execute(target: CreatureCard):
	var dmg = Damage.new(6, Enum.DMG_TYPE.PHYSICAL, target, null)
	var is_percing_dmg = Utils.calc_chance(30)
	
	if is_percing_dmg: 
		dmg.value += 4
		print('4 Piercing damage')
	target.damage(dmg)
		
