extends Resource
class_name DebuffImmunity

var immunities: Array[String] = []

func is_immune_to(debuff_name: String):
	return debuff_name in immunities
