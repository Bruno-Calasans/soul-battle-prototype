class_name Utils

static func calc_chance(chance: int) -> bool:
	var rng = RandomNumberGenerator.new()
	var random_number = rng.randi_range(1, 100)
	return random_number >= chance


static func set_label_font_color(label: Label, color: Color):
	label.add_theme_color_override('font_color', color)
	
