extends CreaturePassiveSkill
class_name DwarfPassiveSkill

func _init():
	spike = SpikePassiveSkill.new(20, 50, [Enum.DMG_TYPE.PHYSICAL], Enum.DMG_TYPE.PHYSICAL)
