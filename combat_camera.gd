extends Camera3D
 
@onready var noise = FastNoiseLite.new()
 
@export var decay : float = 0.5  
@export var amplitude : float = 15.0
 
var trauma = 0.0
var trauma_power = 2 
var NOISE_SPEED = 5
var _noise_y = 0


func _ready():
	randomize()
	noise.seed = randi()
	noise.noise_type = FastNoiseLite.TYPE_PERLIN
 
func _physics_process(delta):
	if trauma:
		trauma = max(trauma - decay * delta, 0)
		_noise_y += NOISE_SPEED
		_shake()
 
func add_trauma(amount: float):
	trauma = min(trauma + amount, 1.0)
 
func _shake():
	var amount = pow(trauma,trauma_power)
	position.x +=  amplitude * amount * noise.get_noise_2d(noise.seed,_noise_y)
	position.z +=  amplitude * amount * noise.get_noise_2d(noise.seed*2,_noise_y)
 
#func _input(event):
	#if event.is_action_pressed("shake"):
		#add_trauma(0.6)
