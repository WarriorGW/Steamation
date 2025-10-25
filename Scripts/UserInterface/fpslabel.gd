extends Label

var fps_min: int = 9999
var fps_max: int = 0
var fps_avg: float = 0.0

# Para calcular promedio
var fps_accumulator: float = 0.0
var fps_frames: int = 0
var avg_timer: float = 0.0
var avg_interval: float = 1.0  # Promedio cada 1 segundo

# Para recalcular mínimo
var min_timer: float = 0.0
var min_interval: float = 5.0  # Mínimo cada 5 segundos
var fps_values_for_min: Array = []

func _process(delta: float) -> void:
	var current_fps = Engine.get_frames_per_second()

	# Actualizamos máximo
	fps_max = max(fps_max, current_fps)

	# Acumulamos para promedio
	fps_accumulator += current_fps
	fps_frames += 1
	avg_timer += delta

	if avg_timer >= avg_interval:
		fps_avg = fps_accumulator / fps_frames
		fps_accumulator = 0
		fps_frames = 0
		avg_timer = 0

	# Acumulamos valores para recalcular mínimo
	fps_values_for_min.append(current_fps)
	min_timer += delta

	if min_timer >= min_interval:
		if fps_values_for_min.size() > 0:
			fps_min = fps_values_for_min.min()
		fps_values_for_min.clear()
		min_timer = 0

	# Mostramos en el Label
	text = "FPS: %d\nAVG: %.1f\nMIN: %d\nMAX: %d" % [current_fps, fps_avg, fps_min, fps_max]
