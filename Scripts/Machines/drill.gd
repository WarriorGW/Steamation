extends "res://Scripts/Machines/Machine.gd"

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func process_cycle():
	add_item("coal", 4)
	add_item("iron", 1)
