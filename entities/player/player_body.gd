class_name PlayerBody 
extends CharacterBody3D
@onready var camera: Camera3D = $Pivot/SpringArm3D/Camera3D
@onready var mesh: MeshInstance3D = $MeshInstance3D
@onready var pivot: Node3D = $Pivot
@onready var spring: SpringArm3D = $Pivot/SpringArm3D
var physics_state: Callable = physics_state_default


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _physics_process(_delta: float) -> void:
	physics_state.call()


func physics_state_default():
	velocity.y = max(velocity.y - 2, -50)
	
	var input := Input.get_vector(  
		"move_left", "move_right", "move_up", "move_down"
	)
	input = input.rotated(-pivot.rotation.y)
	velocity.x = input.x * 4
	velocity.z = input.y * 4
	if input != Vector2.ZERO:
		mesh.rotation.y = lerp_angle(
			mesh.rotation.y, 
			-input.angle() - deg_to_rad(90), 
			0.2
		)
	
	if is_on_floor() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = 27
	
	move_and_slide()


func physics_state_water():
	var input := Input.get_vector(  
		"move_left", "move_right", "move_up", "move_down"
	)
	velocity = input.y * spring.global_basis.z * 4
	mesh.rotation = spring.global_rotation
	mesh.rotation_degrees.y += 180
	move_and_slide()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion \
	and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		move_camera(event.relative.x, event.relative.y, 0.005)
		
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
	spring.rotation.x = clamp(
		spring.rotation.x + y * sensitivty,
		-deg_to_rad(45),
		deg_to_rad(45)
	)


func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("water_area"):
		physics_state = physics_state_water


func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("water_area"):
		physics_state = physics_state_default
