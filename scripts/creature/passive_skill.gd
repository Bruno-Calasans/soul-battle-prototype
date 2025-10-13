extends Resource
class_name CreaturePassiveSkill


# Offensive skills
var basic_atk_ignores: BasicAtkIgnoresPassiveSkill = null
var basic_atk_effect: BasicAtkEffectPassiveSkill = null

# Defensive skills
var dodge: DodgePassiveSkill = null
var spike: SpikePassiveSkill = null
var destruction_effect: DestructionEffectSkill = null
var passive_regeneration: RegenHealthPassiveSkill = null
