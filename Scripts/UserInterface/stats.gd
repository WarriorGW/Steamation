extends PanelContainer

@onready var money_label = $MarginContainer/HBoxContainer/Label

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_on_money_changed(PlayerData.money)
	
	# Conectar al autoload PlayerData
	if not PlayerData.money_changed.is_connected(_on_money_changed):
		PlayerData.money_changed.connect(_on_money_changed)

func _on_money_changed(new_value):
	money_label.text = str(new_value)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
