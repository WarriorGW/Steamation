extends Node2D

signal player_entered(machine)
signal player_exited(machine)

@onready var area: Area2D = $Area2D
@onready var machine_inventory: Control = $MachineInventory
@onready var toggle_btn: Button = $ToggleBtn
@onready var animation_player: AnimationPlayer = $AnimationPlayer

@onready var ui_inventory = get_tree().root.get_node("Game/CanvasLayer/MachineDashboard")

@export var production_time: float = 5.0   # cada cuántos segundos produce
@export var upgrades_slots: int = 1        # espacios para mejoras
@export var inventory_size: int = 10       # tamaño del inventario base

var timer: float = 0.0
var inventory := {}
var upgrades := []

var player_near := false

func _process(delta):
	timer += delta
	if timer >= production_time:
		process_cycle()
		timer = 0

func process_cycle():
	# Este método se sobreescribe en cada máquina
	pass

func add_item(item: String, amount: int = 1):
	if inventory.has(item):
		inventory[item] += amount
	else:
		inventory[item] = amount

func remove_item(item: String, amount: int = 1) -> bool:
	if inventory.has(item) and inventory[item] >= amount:
		inventory[item] -= amount
		return true
	return false

func apply_upgrade(upgrade_data):
	upgrades.append(upgrade_data)
	# ejemplo: reducción de tiempo
	if upgrade_data.has("time_multiplier"):
		production_time *= upgrade_data["time_multiplier"]

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
	var player = get_tree().get_first_node_in_group("player")
	if player:
		player.add_money(50)  # Le das 50 de dinero al jugador
	if ui_inventory.visible:
		ui_inventory.close()
	else:
		ui_inventory.open(self)

func _input(event):
	if event.is_action_pressed("open_inventory") and player_near:
		toggle_machine_inventory()
		get_viewport().set_input_as_handled()
