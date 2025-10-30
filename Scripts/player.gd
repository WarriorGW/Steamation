extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var speed = 100.0
var last_facing_back = false

func _ready() -> void:
	add_to_group("player")

func _physics_process(_delta: float) -> void:
	get_input()
	move_and_slide()

func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	
	if input_direction == Vector2.ZERO:
		velocity = Vector2.ZERO
		update_animation("idle")
		return
	
	velocity = input_direction * speed

	# Determinar si la dirección es hacia atrás (N, NO o NE)
	if input_direction.y < -0.3:
		# Norte puro o inclinado hacia norte
		last_facing_back = true
	else:
		# Sur, Este, Oeste o diagonales hacia abajo
		last_facing_back = false

	# Flip horizontal solo si va hacia la izquierda o derecha
	animated_sprite_2d.flip_h = input_direction.x < 0

	update_animation("walk")

func update_animation(state: String):
	var anim_name = state
	if last_facing_back:
		anim_name += "_back"

	if animated_sprite_2d.animation != anim_name:
		animated_sprite_2d.play(anim_name)
