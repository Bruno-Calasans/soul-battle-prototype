extends Marker2D
class_name FloatingNumber

@onready var text_label: Label = $Text


static func popup(config: Dictionary[String, Variant]):
	
	var text: String = config['text']
	var text_color: Color = config['text_color']
	var scene: Node = config['scene']
	var popup_position: Vector2 = config['position']
	
	var floating_scene: PackedScene = load("res://scenes/floating_number.tscn")
	var floating: FloatingNumber = floating_scene.instantiate()
	
	floating.global_position = popup_position
	floating.call_deferred('set_text', text, text_color)
	scene.add_child(floating)
	
	
func _enter_tree() -> void:
	print('Floating global position = ', global_position)
	
	
func set_text(text: String, color: Color = Color.WHITE):
	if text_label and text_label.ready:
		text_label.text = text
		text_label.add_theme_color_override("font_color", color)
