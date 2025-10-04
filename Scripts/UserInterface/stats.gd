extends PanelContainer

@onready var money_label = $MarginContainer/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.connect("money_changed", Callable(self, "_on_money_changed"))
		_on_money_changed(player.money)

func _on_money_changed(new_value):
	money_label.text = str(new_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
