extends Resource
class_name Damage

const DMG_TYPE = Enum.DMG_TYPE

var value: int = 0
var type: DMG_TYPE = DMG_TYPE.PHYSICAL
var origin: CreatureCard = null
var target: CreatureCard = null


func _init(value: int, type: DMG_TYPE, target: CreatureCard, origin: CreatureCard):
	self.value = value
	self.type = type
	self.target = target
	self.origin = origin
	
