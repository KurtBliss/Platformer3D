extends AnimationPlayer

@onready var body: PlayerBody = $".."

func _process(delta: float) -> void:
	var vel = Vector2(body.velocity.x, body.velocity.z)
	if not body.is_on_floor():
		play("Jump", 0.1)
	elif vel.length() > 0:
		play("Walk", 0.1, vel.length() / 4)
	else:
		play("Idle", 0.2) 
