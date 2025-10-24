extends Resource
class_name CreaturePassiveSkill


# Offensive skills
var basic_atk_ignores: BasicAtkIgnoresPassiveSkill
var basic_atk_effect: BasicAtkEffectPassiveSkill

# Defensive skills
var dodge: DodgePassiveSkill
var spike: SpikePassiveSkill
var destruction_effect: DestructionEffectSkill
var passive_regeneration: RegenHealthPassiveSkill
