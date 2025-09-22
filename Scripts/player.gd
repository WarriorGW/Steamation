extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 100.0
var last_direction = "down"

# Diccionario para mapear vectores → direcciones
var direction_map = {
	Vector2.LEFT: "left",
	Vector2.RIGHT: "right",
	Vector2.UP: "up",
	Vector2.DOWN: "down"
}

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
	
	# Detectar si nos estamos moviendo en el eje horizontal o vertical
	#if abs(input_direction.x) > abs(input_direction.y):
		## Movimiento horizontal
		#if input_direction.x > 0:
			#last_direction = "right"
			## Cambiar la orientacion del sprite
			#animated_sprite_2d.flip_h = false
			##print("Going Right")
		#else:
			#last_direction = "left"
			## Cambiar la orientacion del sprite
			#animated_sprite_2d.flip_h = true
			##print("Going Left")
	#else:
		## Movimiento vertical
		#if input_direction.y > 0:
			#last_direction = "down"
			##print("Going Down")
		#else:
			#last_direction = "up"
			##print("Going Up")
			
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
