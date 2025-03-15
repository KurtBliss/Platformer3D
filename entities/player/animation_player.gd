extends AnimationPlayer

@onready var body: PlayerBody = $".."

func _process(_delta: float) -> void:
	var vel = Vector2(body.velocity.x, body.velocity.z)
	if body.physics_state == body.physics_state_water:
		play("Walk", 0.1, vel.length() / 4)
		$"../MeshInstance3D".rotation_degrees.x = 90
	elif not body.is_on_floor():
		play("Jump", 0.1)
		$"../MeshInstance3D".rotation_degrees.x = 0
	elif vel.length() > 0:
		play("Walk", 0.1, vel.length() / 4)
		$"../MeshInstance3D".rotation_degrees.x = 0
	else:
		play("Idle", 0.2) 
		$"../MeshInstance3D".rotation_degrees.x = 0
