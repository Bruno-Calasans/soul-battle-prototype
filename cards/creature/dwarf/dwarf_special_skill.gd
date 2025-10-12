extends CreatureSpecialSkill
class_name DwarfSpecialSkill


func _init():
	skill_name = 'Terremoto'
	skill_type = Enum.CREATURE_ATK_TYPE.SPECIAL
	

func execute(target: CreatureCard):
	
	# do damage
	var dmg = Damage.new(3, Enum.DMG_TYPE.EARTH, target, null)
	target.damage(dmg)
	
	# apply stun
	if Utils.calc_chance(30):
		var stun = StunEffect.new(3)
		target.effects_manager.add_effect(stun)
		
