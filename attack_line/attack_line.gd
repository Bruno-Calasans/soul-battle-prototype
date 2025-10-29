extends Node2D
class_name AttackLine

@onready var line: Line2D = $Line2D
@onready var icon: TextureRect = $AttackIcon

var from: Vector2
var to: Vector2
var active: bool = false
var icon_y_offset: float = 10


func _ready() -> void:
	line.texture_mode = Line2D.LINE_TEXTURE_TILE
	line.texture_repeat = CanvasItem.TEXTURE_REPEAT_MIRROR
	line.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	

func _input(event: InputEvent) -> void:
	if event.is_action("cancel_action"):
		stop()
		


func _process(delta):
	if active:
		update_target(get_global_mouse_position())
		

func start(from_pos: Vector2):
	z_index = 10
	from = from_pos
	to = from_pos
	active = true
	show()
	_update_line()


func update_target(target_pos: Vector2):
	if not active: return
	to = target_pos
	_update_line()


func stop():
	active = false
	hide()
	
	
func _update_line():
	line.points = [from, to]
	
	# determine icon posision
	var icon_pos_x := to.x - icon.size.x / 2
	var icon_pos_y := to.y -  icon.size.y / 2 - icon_y_offset
	icon.position = Vector2(icon_pos_x, icon_pos_y)
	
	
