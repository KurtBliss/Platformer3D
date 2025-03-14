class_name PlayerBody 
extends CharacterBody3D
@onready var pivot: Node3D = $Pivot
@onready var spring: SpringArm3D = $Pivot/SpringArm3D
@onready var mesh: MeshInstance3D = $MeshInstance3D


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(delta: float) -> void:
	velocity.y = max(velocity.y - 5, -100)
	
	var direction := Input.get_vector(  
		"move_left", "move_right", "move_up", "move_down"
	)
	direction = direction.rotated(-pivot.rotation.y)
	velocity.x = direction.x * 10
	velocity.z = direction.y * 10
	if direction != Vector2.ZERO:
		mesh.rotation.y = lerp_angle(
			mesh.rotation.y, 
			-direction.angle() - deg_to_rad(90), 
			0.2
		)
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = 60
	
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion \
	and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		move_camera(event.relative.x, event.relative.y, 0.02)
		
	if event is InputEventKey:
		if !event.is_pressed():
			return
		
		if event.keycode == KEY_ESCAPE:
			get_tree().quit()
		
		if event.keycode == KEY_F1:
			if Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
				Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
			else:
				Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func move_camera(x, y, sensitivty):
	pivot.rotation.y -= x * sensitivty
	spring.rotation.x += y * sensitivty
