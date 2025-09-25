extends HBoxContainer

@onready var toggle_button: Button = $ToggleButton
@onready var right_side_content: PanelContainer = $RightSideContent

var icon_normal: AtlasTexture
var icon_flipped: AtlasTexture

func toggle_visibility(object):
	var base_icon := toggle_button.icon as AtlasTexture
	
	icon_normal = base_icon.duplicate()
	icon_normal.region = Rect2(Vector2(16, 48), Vector2(16, 16))  # coordenadas normales
	
	icon_flipped = base_icon.duplicate()
	icon_flipped.region = Rect2(Vector2(32, 48), Vector2(16, 16)) # coordenadas flipantes
	
	if object.visible:
		object.visible = false
		toggle_button.icon = icon_normal
	else:
		object.visible = true
		toggle_button.icon = icon_flipped

func _on_toggle_button_pressed() -> void:
	toggle_visibility(right_side_content)
