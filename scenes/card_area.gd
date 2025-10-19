extends Area2D
class_name CardArea

var dragged_card: Card = null
var screen_size: Vector2
var is_hovering_card: bool = false
var default_scale: Vector2
var drag_scale: Vector2
var highlight_scale: Vector2
var start_position: Vector2


func highlight_card(hovered: bool):
	var card_texture: TextureRect = get_parent()
	
	if hovered:
		card_texture.scale = highlight_scale
		card_texture.z_index = 2
	else:
		card_texture.scale = default_scale
		card_texture.z_index = 1


func _on_mouse_entered() -> void:
	get_tree().call_group('Field', '_on_card_hovered_on', get_parent())
	if !is_hovering_card:
		is_hovering_card = true
		highlight_card(true)
		

func _on_mouse_exited() -> void:
	var event = EventBus.new()
	highlight_card(false)
	event.emit_signal('on_card_hovered_off', get_parent())
