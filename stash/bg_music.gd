class_name BgMusic extends AudioStreamPlayer

func _ready() -> void:
	stream = load("res://assets/bgm_v1.wav")
	playing = true
	finished.connect(loop)

func loop() -> void:
	playing = true
