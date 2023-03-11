@tool
extends VisualShaderNodeCustom
class_name VisualShaderNodeBlenderBrick


func _get_name():
	return "Fresnel"


func _get_category():
	return "Blender/Input"


func _get_description():
	return "Produce a blending factor depending on the angle between the surface normal and the view direction using Fresnel equations.\nTypically used for mixing reflections at grazing angles"

func _init():
	set_input_port_default_value(0, 1.45) # IOR
	#                                     # Normal set by _get_code()

func _get_return_icon_type():
	return PORT_TYPE_SCALAR


func _get_input_port_count():
	return 2


func _get_input_port_name(port):
	return [
			"IOR",
			"Normal"
			][port]


func _get_input_port_type(port):
	return [
			PORT_TYPE_SCALAR,   # IOR
			PORT_TYPE_VECTOR_3D # Normal
			][port]


func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "Fac"


func _get_output_port_type(port):
	return PORT_TYPE_SCALAR

func _get_global_code(mode):
	return '#include "res://shaders/includes/fresnel.gdshaderinc"'

func _get_code(input_vars, output_vars, mode, type):
	# Input Vars
	
	var ior_str = input_vars[0]
	var norm_str = input_vars[1] if input_vars[1] else "NORMAL"
	
	# Output Vars
	
	var o_fac_str = output_vars[0]
	
	return """
		vec3 N = normalize({norm});
		vec3 V = VIEW;

		float eta = max({ior}, 0.00001);
		{fac} = fresnel_dielectric(V, N, (FRONT_FACING) ? eta : 1.0 / eta);
	""".format({
		"ior": ior_str,
		"norm": norm_str,
		"fac": o_fac_str,
	})
