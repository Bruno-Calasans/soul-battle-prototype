extends Node2D
class_name CardHighlightManager

var is_hovering_card: bool = false
var can_highlight: bool = true
var default_scale: Vector2 = Vector2(0.8, 0.8)
var highlight_scale: Vector2 = default_scale * 1.2

@onready var card_manager: CardManager = $"../CardManager"


func _ready() -> void:
	event_bus.card_hovered_on.connect(_on_card_hovered_on)
	event_bus.card_hovered_off.connect(_on_card_hovered_off)


func highlight_card(card: Card, hovered: bool):
	if not can_highlight: return
	
	var card_texture: TextureRect = card.card_texture
	
	if hovered:
		card_texture.scale = highlight_scale
		card_texture.z_index = 2
	else:
		card_texture.scale = default_scale
		card_texture.z_index = 1


func _on_card_hovered_on(card: Card) -> void:
	if is_hovering_card: return
	is_hovering_card = true
	highlight_card(card, true)
		

func _on_card_hovered_off(card: Card) -> void:
	highlight_card(card, false)
	
	# check if there's any card after hover effect
	var card_after_hover = card_manager.get_first_card()
	
	# hightlight that card (test)
	if card_after_hover and card != card_after_hover:
		highlight_card(card, true)
	else:
		is_hovering_card = false
		
