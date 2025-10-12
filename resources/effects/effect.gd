extends Node
class_name Effect

# Enums
const EFFECT_TYPE = Enum.EFFECT_TYPE

@export var base_name: String = 'Test'
@export var type: EFFECT_TYPE = EFFECT_TYPE.BUFF
@export var total_turns: int = 5
@export var left_turns: int = 2
@export var is_permanent: bool = false

@onready var effect_level_panel: Panel = $EffectTexture/EffectIcon/EffectLevel
@onready var effect_level_label: Label = $EffectTexture/EffectIcon/EffectLevel/EffectLevelLabel
@onready var effect_level_icon: TextureRect = $EffectTexture/EffectIcon


func hide_effect_level():
	if effect_level_panel and effect_level_panel.ready:
		effect_level_panel.hide()
	

func show_effect_level():
	if effect_level_panel and effect_level_panel.ready:
		effect_level_panel.show()


func is_first_time():
	return !is_expired() and total_turns == left_turns


func is_expired() -> bool:
	return left_turns < 0 and !is_permanent


func set_total_turns(turns: int):
	total_turns = turns
	left_turns = turns


func set_effect_icon(url: String):
	if effect_level_icon and effect_level_icon.ready:
		effect_level_icon.texture = load(url)


func set_effect_level(level: int):
	if effect_level_label and effect_level_label.ready:
		effect_level_label.set_text(str(level))


func decrease_turn():
	left_turns -= 1


func set_status(level: int):
	print('Set status level')
	
	
func apply(target: CreatureCard, origin: CreatureCard = null):
	print('Apply effect on this creature')
	

func remove(target: CreatureCard):
	target.effects_manager.remove_effect(base_name)
