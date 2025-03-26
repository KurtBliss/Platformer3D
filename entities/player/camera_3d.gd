extends Camera3D
const WATER_ENVIRONMENT = preload("res://water_environment.tres")

func water_env_on():
	environment = WATER_ENVIRONMENT

func water_env_off():
	environment = null

func _on_area_3d_area_entered(area: Area3D) -> void:
	if area.is_in_group("water_area"):
		water_env_on()

func _on_area_3d_area_exited(area: Area3D) -> void:
	if area.is_in_group("water_area"):
		water_env_off()
