extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var money: int = 0
signal money_changed(new_value)

var speed = 100.0
var last_direction = "down"

# Diccionario para mapear vectores → direcciones
var direction_map = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()
	
func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	# Detectar si estamos quietos
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		#print("Idle")
		update_animation("idle")
		return
	
	# Detectar dirección dominante (x tiene prioridad si hay empate)
	if abs(input_direction.x) >= abs(input_direction.y):
		last_direction = direction_map[Vector2(sign(input_direction.x), 0)]
		animated_sprite_2d.flip_h = input_direction.x < 0
	else:
		last_direction = direction_map[Vector2(0, sign(input_direction.y))]
	
	update_animation("walk")
	velocity = input_direction * speed

func update_animation(state):
	animated_sprite_2d.play(state) # Concatenar + "_" + last_direction cuando tenga el top-down

func add_money(amount: int):
	money += amount
	emit_signal("money_changed", money)
