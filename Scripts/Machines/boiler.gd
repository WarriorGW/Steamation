extends "res://Scripts/Machines/Machine.gd"

var water: float = 0.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func process_cycle():
	if inventory.has("coal") and inventory["coal"] > 0 and water >= 100:
		remove_item("coal", 1)
		water -= 100
		add_item("steam", 10)
