extends Card
class_name CreatureCard

signal on_creature_is_destroyed(attacker: CreatureCard, target: CreatureCard)

# Enums
const DMG_TYPE = Enum.DMG_TYPE
const CREATURE_RACE = Enum.CREATURE_RACE
const CREATURE_RACE_NAMES = Enum.CREATURE_RACE_NAMES
const CREATURE_TYPE = Enum.CREATURE_TYPE
const CREATURE_TYPE_NAMES = Enum.CREATURE_TYPE_NAMES
const CREATURE_TYPE_ICONS = Enum.CREATURE_TYPE_ICONS
const CREATURE_DMG_TYPE_ICONS = Enum.CREATURE_DMG_TYPE_ICONS

# instances
@onready var status: CreatureStatus
@onready var passive_skills: CreaturePassiveSkill
@onready var special_skill: CreatureSpecialSkill
@onready var ultimate_skill: CreatureUltimateSkill
@onready var effects_manager: CreatureEffectsManager = $CreatureEffectsManager
@export var can_attack: bool = true
@export var can_use_special_atk: bool = true
@export var can_dodge: bool = true


# creature card textures and labels 
@onready var dmg_type_icon: TextureRect = $CardTexture/CardBasicInfo/CreatureDmgTypeTexture/CreatureDmgTypeIcon
@onready var atk_label: Label = $CardTexture/CreatureBottomContainer/AtkHealthContainer/CreatureAtkContainer/CreatureAtkLabel
@onready var health_label: Label = $CardTexture/CreatureBottomContainer/AtkHealthContainer/CreatureHealthContainer/CreatureHealthLabel
@onready var physical_armor_label: Label = $CardTexture/CreatureBottomContainer/ArmorContainer/PhysicalArmor/CreaturePhysicalArmorLabel
@onready var magical_armor_label: Label = $CardTexture/CreatureBottomContainer/ArmorContainer/MagicalArmor/CreatureMagicallArmorLabel


func _ready() -> void:
	config({
		'name': 'Creature Card',
		'desc': 'Some creature card',
		'soul_cost': 2,
		'img_url': "res://assets/creature/img/monk.jpeg",
		'base_atk': 3,
		'base_health': 2,
		'base_physical_armor': 4,
		'base_magical_armor': 1,
		'type': CREATURE_TYPE.ANIMAL,
		'race': CREATURE_RACE.HUMAN,
		'dmg_type': DMG_TYPE.FIRE
	})


func config(config: Dictionary[String, Variant]):
	
	# create instances
	status = CreatureStatus.new()
	
	# main creature card config
	set_card_name(config['name'])
	set_card_desc(config['desc'])
	set_soul_cost(config['soul_cost'])
	set_card_img(config['img_url'])
	
	# status config
	status.set_base_atk(config['base_atk'])
	status.set_base_health(config['base_health'])
	status.set_base_physical_armor(config['base_physical_armor'])
	status.set_base_magical_armor(config['base_magical_armor'])
	status.type = config['type']
	status.race = config['race']
	status.dmg_type = config['dmg_type']
	
	
	# visual update
	update_icons_and_imgs()
	update_labels()
	

func update_icons_and_imgs():
	update_card_img()
	update_creature_type_icon()
	update_creature_dmg_type_icon()
		
		
func update_labels():
	update_card_name_label()
	update_card_desc_label()
	update_card_soul_cost_label()
	update_atk_label()
	update_health_label()
	update_physical_armor_label()
	update_magical_armor_label()
	update_creature_tags_label()
	
	
func update_creature_tags_label():
	var race_name = CREATURE_RACE_NAMES[status.race]
	var rarity_name = CARD_RARITY_NAMES[rarity]
	update_card_tags([race_name, rarity_name])
	

func update_creature_type_icon():
	var creature_type = status.type
	update_type_icon(CREATURE_TYPE_ICONS[creature_type])	
	
	
func update_creature_dmg_type_icon():
	var dmg_type = status.dmg_type
	set_dmg_type_icon(dmg_type)


func update_atk_label():
	var current_atk = status.current_atk
	var base_atk = status.base_atk
	
	if(atk_label and atk_label.ready):
		atk_label.set_text(str(current_atk))
		if current_atk < base_atk:
			Utils.set_label_font_color(atk_label, Color.RED)
			
		if current_atk > base_atk:
			Utils.set_label_font_color(atk_label, Color.GREEN)
		

func update_health_label():
	var current_health = status.current_health
	var base_health = status.base_health
	
	if(health_label and health_label.ready):
		health_label.set_text(str(current_health))
		if current_health < base_health:
				Utils.set_label_font_color(health_label, Color.RED)
		if current_health > base_health:
				Utils.set_label_font_color(health_label, Color.GREEN)
			

func update_physical_armor_label():
	var current_physical_armor = status.current_physical_armor
	var base_physical_armor = status.base_physical_armor
	
	if(physical_armor_label and physical_armor_label.ready):
		physical_armor_label.set_text(str(current_physical_armor))
		if current_physical_armor < base_physical_armor:
			Utils.set_label_font_color(physical_armor_label, Color.RED)
		if current_physical_armor > base_physical_armor:
			Utils.set_label_font_color(physical_armor_label, Color.GREEN)


func update_magical_armor_label():
	var current_magical_armor = status.current_magical_armor
	var base_magical_armor = status.base_magical_armor
	
	if(magical_armor_label and magical_armor_label.ready):
		magical_armor_label.set_text(str(current_magical_armor))
		if current_magical_armor < base_magical_armor:
			Utils.set_label_font_color(magical_armor_label, Color.RED)
		if current_magical_armor > base_magical_armor:
			Utils.set_label_font_color(magical_armor_label, Color.GREEN)


func set_dmg_type_icon(dmg_type: DMG_TYPE):
	if(dmg_type_icon and dmg_type_icon.ready):
		var texture = load(CREATURE_DMG_TYPE_ICONS[dmg_type])
		dmg_type_icon.texture = texture
		
	
func do_direct_damage(dmg_value: int):
	#print('Doing direct damage  = ' + str(dmg_value))
	status.modify_health_by(-dmg_value)
	

func do_physical_damage(dmg_value: int, attacker: CreatureCard):
	#print('Doing physical damage  = ' + str(dmg_value))
	
	var ignores_atk = attacker.passive_skills and attacker.passive_skills.basic_atk_ignores
	var ignores_physical_armor = ignores_atk and ignores_atk.physical_armor 
	var no_physical_armor = status.current_physical_armor == 0
	
	if ignores_physical_armor or no_physical_armor:
		do_direct_damage(dmg_value)
		
	else:
		status.set_physical_armor_after_dmg(dmg_value)
	
	
func do_magical_damage(dmg_value: int, attacker: CreatureCard):
	#print('Doing magical damage  = ' + str(dmg_value))
	
	var ignores_magical_armor = attacker.passive_skills and attacker.passive_skills.basic_atk_ignores.magical_amor
	var no_magical_armor = status.current_magical_armor == 0
	
	if ignores_magical_armor or no_magical_armor:
		do_direct_damage(dmg_value)
		
	else:
		status.set_magical_armor_after_dmg(dmg_value)


func damage(dmg: Damage):
	
	# apply damage resistence
	status.dmg_resistence.apply_dmg_resistence(dmg)
	
	# direct damage
	if dmg.type == DMG_TYPE.DIRECT:
		do_direct_damage(dmg.value)
		
	# physical damage
	elif dmg.type == DMG_TYPE.PHYSICAL:
		do_physical_damage(dmg.value, self)
	
	# magical damage
	else:
		do_magical_damage(dmg.value, self)
	
	# checks target spike skill
	if dmg.target.passive_skills and dmg.target.passive_skills.spike:
		dmg.target.passive_skills.spike.execute(dmg)
		
		
	if status.current_health == 0:
		print('creature is dead = ', card_name)
		on_creature_is_destroyed.emit(dmg.origin, self)
	
	# after dmgs
	update_labels()
	
	
func regen(source: Enum.REGEN_SOURCE, health: int):
	var source_chance: Dictionary = status.regeneration.get_source_chance(source)
	var health_multiplier: float = source_chance['current_chance'] / 100
	var heal_value = floor(health * health_multiplier)
	status.modify_health_by(heal_value)
	update_health_label()

	
func do_basic_atk(target: CreatureCard):
	var dmg = Damage.new(status.current_atk, status.dmg_type, target, self)
	target.damage(dmg)
	
	# apply effect after basic atk
	if passive_skills and passive_skills.basic_atk_effect:
		passive_skills.basic_atk_effect.apply(self, target)
		

func do_special_atk(target: CreatureCard):
	if special_skill and can_attack:
		special_skill.execute(target)
	
	
func do_ultimate_atk(target: CreatureCard):
	if ultimate_skill:
		ultimate_skill.execute(target)
	
	
# Function to attack others cards
func attack(target: CreatureCard, atk_type: Enum.CREATURE_ATK_TYPE):
	
	print('Can attack = ', can_attack)
	
	if !can_attack: 
		print(card_name, ' cant attack')
		return false
	
	# check target dodge skill
	if target.passive_skills and target.passive_skills.dodge:
		target.passive_skills.dodge.execute(self, target, atk_type)
		return false
	
	# basic atk
	if atk_type == Enum.CREATURE_ATK_TYPE.BASIC:
		do_basic_atk(target)
		
	# special atk
	if atk_type == Enum.CREATURE_ATK_TYPE.SPECIAL:
		do_special_atk(target)
		
	# ultimate atk
	if atk_type == Enum.CREATURE_ATK_TYPE.ULTIMATE:
		do_ultimate_atk(target)
		
		
	return true


func _on_creature_is_destroyed(attacker: CreatureCard, target: CreatureCard) -> void:
	print(target.card_name + ' is destroyed')
	if target.passive_skills and target.passive_skills.destruction_effect:
		print('apply effect = ', target.passive_skills.destruction_effect.effect.base_name)
		target.passive_skills.destruction_effect.execute(attacker)
		
	target.queue_free()
