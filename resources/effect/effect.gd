extends Node
class_name Effect

# Enums
const EFFECT_TYPE = Enum.EFFECT_TYPE

@export var base_name: String = 'Test'
@export var icon_url: String = ''
@export var type: EFFECT_TYPE = EFFECT_TYPE.BUFF
@export var total_turns: int = 5
@export var left_turns: int = 2
@export var is_permanent: bool = false
@export var desc: String = 'Test effect'


# Instances
@onready var effect_level_panel: Panel = $Icon/LevelContainer
@onready var effect_level_label: Label = $Icon/LevelContainer/LevelLabel
@onready var effect_level_icon: TextureRect = $Icon
@onready var effect_tooltip: Tooltip = $Tooltip


func config_tooltip(title: String, icon_url: String, content: String, left_turns: int):
	if effect_level_icon and effect_level_icon.ready:
		effect_level_icon.mouse_entered.connect(show_tooltip)
		effect_level_icon.mouse_exited.connect(hide_tooltip)
		effect_tooltip.config(title, icon_url, content, left_turns)
	
	
		
func show_tooltip():
	effect_tooltip.toggle(true)
	

func hide_tooltip():
	effect_tooltip.toggle(false)


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
	icon_url = url
	if effect_level_icon and effect_level_icon.ready:
		effect_level_icon.texture = load(url)


func set_effect_level_text(level: int):
	if effect_level_label and effect_level_label.ready:
		effect_level_label.set_text(str(level))


func decrease_turn():
	effect_tooltip.set_left_turns_label(left_turns)
	left_turns -= 1
	

func set_status(level: int):
	print('Set effect status level')
	
	
func apply(target: CreatureCard, origin: CreatureCard = null):
	print('Apply effect on target')
	

func remove(target: CreatureCard):
	print('Remove effect modifications from target')


func _on_mouse_entered() -> void:
	show_tooltip()


func _on_mouse_exited() -> void:
	hide_tooltip()
