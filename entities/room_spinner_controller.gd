@tool
extends Node

@export var node : Node3D
@export_tool_button("Spin") var spin_button = func():
	spin()

func on_spin(body: Node3D):
	if node is Node3D:
		spin()

func spin():
	node.rotation.x += deg_to_rad(90)
