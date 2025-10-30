extends Card
class_name CreatureCard

# Enums
const DMG_TYPE = Enum.DMG_TYPE
const CREATURE_RACE = Enum.CREATURE_RACE
const CREATURE_RACE_NAMES = Enum.CREATURE_RACE_NAMES
const CREATURE_TYPE = Enum.CREATURE_TYPE
const CREATURE_TYPE_NAMES = Enum.CREATURE_TYPE_NAMES
const CREATURE_TYPE_ICONS = Enum.CREATURE_TYPE_ICONS
const CREATURE_DMG_TYPE_ICONS = Enum.CREATURE_DMG_TYPE_ICONS

# instances
@onready var status: CreatureStatus = CreatureStatus.new()
@onready var passive_skills: CreaturePassiveSkill
@onready var special_skill: CreatureSpecialSkill
@onready var ultimate_skill: CreatureUltimateSkill


# creature card textures and labels 
@onready var dmg_type_icon: TextureRect = $CardTexture/CardBasicInfo/CreatureDmgTypeTexture/CreatureDmgTypeIcon
@onready var atk_label: Label = $CardTexture/CreatureBottomContainer/AtkHealthContainer/CreatureAtkContainer/CreatureAtkLabel
@onready var health_label: Label = $CardTexture/CreatureBottomContainer/AtkHealthContainer/CreatureHealthContainer/CreatureHealthLabel
@onready var physical_armor_label: Label = $CardTexture/CreatureBottomContainer/ArmorContainer/PhysicalArmor/CreaturePhysicalArmorLabel
@onready var magical_armor_label: Label = $CardTexture/CreatureBottomContainer/ArmorContainer/MagicalArmor/CreatureMagicallArmorLabel
@onready var effects_manager: CreatureEffectsManager = $EffectsManager
@onready var popup: CreaturePopupNumber = $FloatingPopupPosition


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
		'dmg_type': DMG_TYPE.FIRE,
		'rarity': CARD_RARITY.COMMON
	})
		

func config(config_data: Dictionary[String, Variant]):
	# main card config
	set_card_name(config_data['name'])
	set_card_desc(config_data['desc'])
	set_soul_cost(config_data['soul_cost'])
	set_card_img(config_data['img_url'])
	
	# status config
	status.set_base_atk(config_data['base_atk'])
	status.set_base_health(config_data['base_health'])
	status.set_base_physical_armor(config_data['base_physical_armor'])
	status.set_base_magical_armor(config_data['base_magical_armor'])
	
	set_creature_tags(config_data['race'], config_data['rarity'])
	set_creature_type(config_data['type'])
	set_creature_dmg_type(config_data['dmg_type'])
	
	update_labels()
	
		
func update_labels():
	update_atk_label()
	update_health_label()
	update_physical_armor_label()
	update_magical_armor_label()
	
	
func set_creature_tags(creature_race: Enum.CREATURE_RACE, crature_rarity: Enum.CARD_RARITY):
	status.race = creature_race
	rarity = crature_rarity
	set_card_tags([CREATURE_RACE_NAMES[creature_race], CARD_RARITY_NAMES[crature_rarity]])
	

func set_creature_type(creature_type: Enum.CREATURE_TYPE):
	status.type = creature_type
	set_type_icon(CREATURE_TYPE_ICONS[creature_type])	
	
	
func set_creature_dmg_type(dmg_type: DMG_TYPE):
	status.dmg_type = dmg_type
	if dmg_type_icon and dmg_type_icon.ready:
		var texture = load(CREATURE_DMG_TYPE_ICONS[dmg_type])
		dmg_type_icon.texture = texture


func update_atk_label():
	var current_atk = status.current_atk
	var base_atk = status.base_atk
	
	if(atk_label and atk_label.ready):
		
		atk_label.set_text(str(current_atk))
		Utils.set_label_font_color(atk_label, Color.WHITE)
		
		if current_atk < base_atk:
			Utils.set_label_font_color(atk_label, Color.RED)
			
		if current_atk > base_atk:
			Utils.set_label_font_color(atk_label, Color.GREEN)
		

func update_health_label():
	var current_health = status.current_health
	var base_health = status.base_health
	
	if(health_label and health_label.ready):
		
		health_label.set_text(str(current_health))
		Utils.set_label_font_color(health_label, Color.WHITE)
		
		if current_health < base_health:
				Utils.set_label_font_color(health_label, Color.RED)
		if current_health > base_health:
				Utils.set_label_font_color(health_label, Color.GREEN)
			

func update_physical_armor_label():
	var current_physical_armor = status.current_physical_armor
	var base_physical_armor = status.base_physical_armor
	
	if(physical_armor_label and physical_armor_label.ready):
		physical_armor_label.set_text(str(current_physical_armor))
		Utils.set_label_font_color(physical_armor_label, Color.WHITE)
		
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


func do_direct_damage(dmg_value: int):
	status.modify_health_by(-dmg_value)
	popup.popup_damage(dmg_value)
	

func do_physical_damage(dmg_value: int, attacker: CreatureCard):
	var ignores_physical_armor = attacker.can_ignore_physical_armor()
	var no_physical_armor = status.current_physical_armor == 0
	
	if ignores_physical_armor or no_physical_armor:
		do_direct_damage(dmg_value)
		
	else:
		status.set_physical_armor_after_dmg(dmg_value)
		popup.popup_physical_armor_damage(dmg_value)
	

func can_ignore_magical_armor() -> bool:
	if not passive_skills: return false
	if not passive_skills.basic_atk_ignores: return false	
	if not passive_skills.basic_atk_ignores.magical_armor: return false
	return true
	
	
func can_ignore_physical_armor() -> bool:
	if not passive_skills: return false
	if not passive_skills.basic_atk_ignores: return false	
	if not passive_skills.basic_atk_ignores.physical_amor: return false
	return true
	
	
func do_magical_damage(dmg_value: int, attacker: CreatureCard):
	var ignores_magical_armor = attacker.can_ignore_magical_armor()
	var no_magical_armor = status.current_magical_armor == 0
	
	if ignores_magical_armor or no_magical_armor:
		do_direct_damage(dmg_value)
		
	else:
		status.set_magical_armor_after_dmg(dmg_value)
		popup.popup_magical_armor_damage(dmg_value)


func check_before_dmg(dmg: Damage):
	status.dmg_resistence.apply_dmg_resistence(dmg)
	

func check_after_damage(dmg: Damage):
	# check spike effect
	if passive_skills and passive_skills.spike:
		passive_skills.spike.execute(dmg)
		
	# card is destroyed
	if status.current_health == 0:
		
		# check destruction effect
		if passive_skills and passive_skills.destruction_effect:
			passive_skills.destruction_effect.execute(dmg.origin)
			
		# global event to listeners
		# card slot
		# void
		destroy()
		event_bus.on_card_destroyed.emit(self)
		

# This creature takes damage
func damage(dmg: Damage):
	
	# apply damage resistence
	# apply damage resistence
	check_before_dmg(dmg)
	
	# direct damage
	if dmg.type == DMG_TYPE.DIRECT:
		do_direct_damage(dmg.value)
		
	# physical damage
	elif dmg.type == DMG_TYPE.PHYSICAL:
		do_physical_damage(dmg.value, self)
	
	# magical damage
	else:
		do_magical_damage(dmg.value, self)
	
	# spike check
	check_after_damage(dmg)
	update_labels()
	
	
# Heal this creature
func regen(source: Enum.REGEN_SOURCE, health: int) -> bool:
	if !status.can_heal: return false
	
	var regen_source: Dictionary = status.regeneration.get_source_chance(source)
	var health_multiplier: float = regen_source['current_chance'] / 100
	var heal_value: int = round(health * health_multiplier)
	
	status.modify_health_by(heal_value)
	update_health_label()
	
	if popup: popup.popup_heal(health)
	return true

	
func do_basic_atk(target: CreatureCard):
	if not status.can_attack: return
	var dmg = Damage.new(status.current_atk, status.dmg_type, target, self)
	target.damage(dmg)
		


func can_do_special_atk() -> bool:
	return  status.can_attack and status.can_use_special_atk and special_skill


func do_special_atk(target: CreatureCard):
	if can_do_special_atk(): special_skill.execute(target)
	

func can_do_ultimate_atk() -> bool:
	return 	status.can_attack and status.can_use_ultimate_atk and ultimate_skill
	
	
func do_ultimate_atk(target: CreatureCard):
	if can_do_ultimate_atk():
		ultimate_skill.execute(target)
	

func check_before_attack(target: CreatureCard, atk_type: Enum.CREATURE_ATK_TYPE) -> bool:
	if !status.can_attack: 
		print(card_name, " can't attack")
		return false
		
	if target.passive_skills and target.passive_skills.dodge:
		var attack_was_dodged := target.passive_skills.dodge.execute(self, target, atk_type)
		return attack_was_dodged
		
	return true
	
	
func check_after_attack(target: Card, atk_type: Enum.CREATURE_ATK_TYPE):
	# apply effect after basic atk
	if atk_type == Enum.CREATURE_ATK_TYPE.BASIC and passive_skills and passive_skills.basic_atk_effect:
		passive_skills.basic_atk_effect.execute(target)
		

# This creature attacks others cards 
func attack(target: CreatureCard, atk_type: Enum.CREATURE_ATK_TYPE = Enum.CREATURE_ATK_TYPE.BASIC):
	
	# before attack
	var can_continue_attack := check_before_attack(target, atk_type)
	if not can_continue_attack: return
	
	# basic atk
	if atk_type == Enum.CREATURE_ATK_TYPE.BASIC:
		do_basic_atk(target)
		
	# special atk
	if atk_type == Enum.CREATURE_ATK_TYPE.SPECIAL:
		do_special_atk(target)
		
	# ultimate atk
	if atk_type == Enum.CREATURE_ATK_TYPE.ULTIMATE:
		do_ultimate_atk(target)
		
	# after attack
	check_after_attack(target, atk_type)
		
