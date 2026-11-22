extends Camera2D
"""
Holds functions for camera effects. E.g. camera shake.
"""

@onready var noise = FastNoiseLite.new()
var noise_y = 0

## Camera shaking parameters
@export_category('Shake')
## How quickly shaking disappears
@export var decay:float = 0.8
## Maximum camera offsert in px
@export var max_offset:Vector2i=Vector2i(100,80)
## Maximum rotation of camera in radians
@export var max_roll:float = 0.1
var trauma:float=0.0
var trauma_power = 2.0


func _ready() -> void:
	randomize()
	noise.seed = randi()

func _process(delta: float) -> void:
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_shake()

func add_trauma(amount:float=1.0)->void:
	## Adds trauma, and starts camera shake

	print('Adding trauma ', amount)
	trauma = min(trauma+amount,1.0)

func _shake()->void:
	"""
	Do not call on itself. Use `add_trauma` instead
	Shakes the camera.
	"""
	var amount = pow(trauma, trauma_power)
	noise_y += 1
	rotation = max_roll * amount * noise.get_noise_2d(noise.seed, noise_y)
	offset.x = max_offset.x * amount * noise.get_noise_2d(noise.seed*2, noise_y)
	offset.y = max_offset.y * amount * noise.get_noise_2d(noise.seed*3, noise_y)
