extends Marker2D
class_name CreaturePopupNumber

func popup(value: int, type: Enum.POPUP_TYPE, sufix: String = '-'):
	FloatingNumber.popup({
			'text': sufix + str(value),
			'text_color': Enum.POPUP_COLORS[type],
			'position': position,
			'scene': get_parent()
		})
	

func popup_heal(value: int):
	popup(value, Enum.POPUP_TYPE.HEAL, '+')
	
	
func popup_damage(value: int):
	popup(value, Enum.POPUP_TYPE.DAMAGE)
	

func popup_physical_armor_damage(value: int):
	popup(value, Enum.POPUP_TYPE.PHYSICAL_ARMOR_DAMAGE)
	

func popup_magical_armor_damage(value: int):
	popup(value, Enum.POPUP_TYPE.MAGICAL_ARMOR_DAMAGE)
