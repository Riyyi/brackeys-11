extends Area3D

@onready var particles : GPUParticles3D
@onready var particlebeam : GPUParticles3D
@onready var progressparticles1 : GPUParticles3D
@onready var progressparticles2 : GPUParticles3D
@onready var rotor : Node3D

var on_teleporter = false

var timer = 0
var time_reached = 10

# Called when the node enters the scene tree for the first time.
func _ready():
	particles = get_node("../GPUParticles3D")
	particlebeam = get_node("../GPUParticles3D2")
	progressparticles1 = get_node("../Rotor/GPUParticles3D3")
	progressparticles2 = get_node("../Rotor/GPUParticles3D4")
	rotor = get_node("../Rotor")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if on_teleporter == true:
		timer += delta
		rotor.rotate(Vector3(0.0, 1.0, 0.0), delta * (timer / 2.0))
		rotor.position.y = timer * (3.0 / time_reached)
		progressparticles1.amount_ratio = (1.0 / time_reached) * timer
		progressparticles2.amount_ratio = (1.0 / time_reached) * timer
		print(timer, progressparticles1.amount_ratio)
		if timer > time_reached:
			print("next level")

func _on_body_entered(body):
	if "Player" in body.name:
		on_teleporter = true

func _on_body_exited(body):
	if "Player" in body.name:
		on_teleporter = false
		timer = 0
		progressparticles1.amount_ratio = 0
		progressparticles2.amount_ratio = 0
