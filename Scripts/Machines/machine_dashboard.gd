extends Control

@onready var machine_name: Label = $PanelContainer/VBoxContainer/MarginContainer/MachineName

var current_machine: Node = null

func open(machine: Node):
	current_machine = machine
	visible = true
	machine_name.text = "Inventario de %s" % machine.name

func close():
	visible = false
	current_machine = null

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_close_button_pressed() -> void:
	close()
