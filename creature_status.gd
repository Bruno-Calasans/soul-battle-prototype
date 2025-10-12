extends Resource
class_name CreatureStatus


const DMG_TYPE = Enum.DMG_TYPE
const CREATURE_RACE = Enum.CREATURE_RACE
const CREATURE_RACE_NAMES = Enum.CREATURE_RACE_NAMES
const CREATURE_TYPE = Enum.CREATURE_TYPE
const CREATURE_TYPE_NAMES = Enum.CREATURE_TYPE_NAMES
const CREATURE_TYPE_ICONS = Enum.CREATURE_TYPE_ICONS
const CREATURE_DMG_TYPE_ICONS = Enum.CREATURE_DMG_TYPE_ICONS

@export var base_atk: int = 1
@export var current_atk: int = 1
@export var base_health: int = 1
@export var current_health: int = 1
@export var base_physical_armor: int = 1
@export var current_physical_armor: int = 2
@export var base_magical_armor: int = 3
@export var current_magical_armor: int = 3
@export var race: CREATURE_RACE = CREATURE_RACE.HUMAN
@export var dmg_type: DMG_TYPE = DMG_TYPE.PHYSICAL
@export var type: CREATURE_TYPE = CREATURE_TYPE.SKILL


@export var dmg_resistence: DmgResistence = null
@export var debuff_immunity: DebuffImmunity = null
@export var regeneration: RegenerationSource = null


func _init():
	dmg_resistence = DmgResistence.new() 
	debuff_immunity = DebuffImmunity.new()
	regeneration = RegenerationSource.new()

	
func set_base_atk(value: int):
	base_atk =  max(0, value)
	set_current_atk(value)


func set_current_atk(value: int):
	current_atk = max(0, value)
	
	
func set_base_health(value: int):
	base_health = max(0, value)
	set_current_health(value)
	
	
func set_current_health(value: int):
	current_health = max(0, value)
	

func modify_health_by(value: int):
	var new_health_value = max(0, current_health + value)
	set_current_health(new_health_value)
	
	
func set_base_physical_armor(value: int):
	base_physical_armor = value
	set_current_physical_armor(value)


func set_current_physical_armor(value: int):
	current_physical_armor = max(0, value)
	

func modify_physical_armor_by(value: int):
	var new_physical_armor_value = max(0, current_physical_armor + value)
	set_current_physical_armor(new_physical_armor_value)
	

func set_base_magical_armor(value: int):
	base_magical_armor = value
	set_current_magical_armor(value)


func set_current_magical_armor(value: int):
	current_magical_armor = max(0, value)
		

func modify_magical_armor_by(value: int):
	var new_magical_armor_value = max(0, current_magical_armor + value)
	set_current_magical_armor(new_magical_armor_value)


func set_physical_armor_after_dmg(dmg_value: int):
	var dmg_diff = current_physical_armor - dmg_value
	var new_physical_armor = max(0, dmg_diff)
	var direct_dmg = 0
	
	if dmg_diff < 0: direct_dmg = dmg_diff
	
	set_current_physical_armor(new_physical_armor)
	modify_health_by(direct_dmg)


func set_magical_armor_after_dmg(dmg_value: int):
	var dmg_diff = current_magical_armor - dmg_value
	var new_magical_armor = max(0, dmg_diff)
	var direct_dmg = 0
	
	if dmg_diff < 0: direct_dmg = abs(dmg_diff)
	
	set_current_physical_armor(new_magical_armor)
	modify_health_by(direct_dmg)	
	
