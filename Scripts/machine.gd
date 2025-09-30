extends Node2D

signal player_entered(machine)
signal player_exited(machine)

@onready var area: Area2D = $Area2D
@onready var machine_inventory: Control = $MachineInventory
@onready var toggle_btn: Button = $ToggleBtn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

var production_time = 5.0
var timer = 0.0
var output = 0
var is_working = false

var player_near := false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)
	#print("ToggleBtn: ", toggle_btn.visible, "MachineInv: ", machine_inventory.visible)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		emit_signal("player_entered", self)
		#print("Jugador cerca!")
		player_near = true
		animation_player.play("show_machine_button")

func _on_body_exited(body):
	if body.is_in_group("Player"):
		emit_signal("player_exited", self)
		#print("Jugadornt")
		player_near = false
		animation_player.play("hide_machine_button")

func toggle_machine_inventory():
	print("Inventario de maquina")

func _input(event):
	if event.is_action_pressed("open_inventory") and player_near:
		toggle_machine_inventory()
		get_viewport().set_input_as_handled()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
