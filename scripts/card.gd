extends Node2D
class_name Card

# Enums
const CARD_VARIATION = Enum.CARD_VARIATION
const CARD_RARITY = Enum.CARD_RARITY
const CARD_RARITY_NAMES = Enum.CARD_RARITY_NAMES


# Logical properties
@export var card_name: String = 'Card'
@export var soul_cost: int = 2
@export var variation: CARD_VARIATION = CARD_VARIATION.CREATURE
@export var rarity: CARD_RARITY = CARD_RARITY.COMMON
@export var desc: String = ''
@export var img_url: String = ''


# Visual
@onready var name_label: Label = $CardTexture/CardExtraInfoContainer/CardNamePanel/CardNameLabel
@onready var tag_label: Label= $CardTexture/CardExtraInfoContainer/CardTagPanel/CardTagLabel	
@onready var desc_label: RichTextLabel = $CardTexture/CardDescContainer/CardDescLabel
@onready var soul_cost_label: Label = $CardTexture/CardBasicInfo/CardSoulCostTexture/CardSoulCostLabel
@onready var img: TextureRect = $CardTexture/CardImgContainer/CardImg
@onready var type_icon: TextureRect = $CardTexture/CardBasicInfo/CardTypeTexture/CardTypeIcon
@onready var card_texture: TextureRect = $CardTexture
@onready var card_manager: CardManager = $CardTexture/CardArea
@onready var card_collision: CollisionShape2D = $CardTexture/CardArea/Colision


func set_card_name(card_name: String):
	self.card_name = card_name
	
	
func update_card_name_label():
	if(name_label and name_label.ready):
		name_label.set_text(card_name)
	
	
func update_card_tags(tags: Array[String]):
	if(tag_label and tag_label.ready):
		var formatedText = ''
		for tag in tags:
			formatedText += tag + ' '
		formatedText = formatedText.trim_prefix(' ').trim_suffix(' ').replace(' ', ' • ')
		tag_label.set_text(formatedText)
		
	
func set_card_desc(desc: String):
	self.desc = desc
	
	
func update_card_desc_label():
	if(desc_label and desc_label.ready):
		desc_label.set_text(desc)
		

func update_card_soul_cost_label():
	if(soul_cost_label and soul_cost_label.ready):
		soul_cost_label.set_text(str(soul_cost))

		
func set_soul_cost(cost: int):
	soul_cost = max(0, cost)
		

func update_card_img():
	if(img and img.ready):
		img.texture = load(img_url)
	
	
func set_card_img(url: String):
	img_url = url  
	
		
func update_type_icon(url: String):
	if(type_icon and type_icon.ready):
		type_icon.texture = load(url)
