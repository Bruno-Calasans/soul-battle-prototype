extends Card
class_name SpellCard

const SPELL_TYPE_ICONS = Enum.SPELL_TYPE_ICONS

var spell_type: Enum.SPELL_TYPE

func _ready() -> void:
	variation = CARD_VARIATION.SPELL
	set_card_texture("res://assets/spell/base_spell.png")
	

func config(config_data: Dictionary):
	set_card_name(config_data['name'])
	set_card_desc(config_data['desc'])
	set_soul_cost(config_data['soul_cost'])
	set_card_img(config_data['img_url'])
	set_spell_type(config_data['type'])
	
	
func set_spell_type(type: Enum.SPELL_TYPE):
	spell_type = type
	set_type_icon(SPELL_TYPE_ICONS[type])
	


func active(target: Variant):
	print('Active spell card')
