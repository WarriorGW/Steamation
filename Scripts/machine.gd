extends Node2D

signal player_entered(machine)
signal player_exited(machine)

@onready var area: Area2D = $Area2D

var production_time = 5.0
var timer = 0.0
var output = 0
var is_working = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_entered", self)
		print("Jugador cerca!")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		emit_signal("player_exited", self)
		print("Jugador se alejó!")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
