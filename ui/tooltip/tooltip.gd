extends Control
class_name Tooltip

@onready var title_text_label: Label = $Panel/MarginContainer/VBoxContainer/Title/Text
@onready var title_icon: TextureRect = $Panel/MarginContainer/VBoxContainer/Title/Icon
@onready var content_text: RichTextLabel = $Panel/MarginContainer/VBoxContainer/Content
@onready var left_turns_label: Label = $Panel/MarginContainer/VBoxContainer/Title/LeftTurns

var OFFSET: Vector2 = Vector2.ONE * 12.0
var opacity_tween: Tween = null


func config(title: String, icon_url: String, content: String, left_turns: int):
	if ready:
		set_title_text(title)
		set_icon(icon_url)
		set_content(content)
		set_left_turns_label(left_turns)


func _input(event: InputEvent) -> void:
	if visible and event is InputEventMouseMotion:
		var mouse_global_position_vector = get_global_mouse_position()
		global_position = mouse_global_position_vector + OFFSET
	
	
func set_title_text(text: String):
	if title_text_label:
		title_text_label.text = text


func set_icon(icon_url: String):
	if title_icon and title_icon.ready:
		title_icon.texture = load(icon_url)
	

func set_content(text: String):
	if content_text and content_text.ready:
		content_text.text = text
		
	
func set_left_turns_label(value: int):
	if left_turns_label and left_turns_label.ready:
		left_turns_label.text = '%d turno(s)' % [value]
	
	
func toggle(on: bool):
	if on:
		show()
		modulate.a = 0.0
		tween_opacity(1.0)
	else:
		modulate.a = 1.0
		await tween_opacity(0.0).finished
		hide()
		
# 
func tween_opacity(to_value: float):
	if opacity_tween: opacity_tween.kill()
	opacity_tween = create_tween()
	opacity_tween.tween_property(self, 'modulate:a', to_value, 0.3)
	return opacity_tween
	
