@tool
extends DirectionalLight3D
class_name PhysicalSun


@export var height_colors : GradientTexture1D
# Called when the node enters the scene tree for the first time.
func _ready():
	RenderingServer.connect("frame_pre_draw",_on_frame_draw_pre)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_frame_draw_pre():
	var angle = acos(global_transform.basis.z.dot(Vector3(0,-1,0)))
	var thing = angle/PI
#	print(thing)
	light_color = height_colors.gradient.sample(thing)
