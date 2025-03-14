@tool
class_name SpringArm3DPreview
extends SpringArm3D

func _process(_delta):
	if Engine.is_editor_hint():
		for child in get_children():
			if child is Node3D:
				var pos = global_position + (
					spring_length * Vector3.BACK * basis.inverse()
				)
				child.global_position = pos 
