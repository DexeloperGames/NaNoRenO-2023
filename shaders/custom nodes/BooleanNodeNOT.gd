@tool
class_name VisualShaderNodeBooleanNodeNot
extends VisualShaderNodeCustom


func _get_name():
	return "NOT"


func _get_category():
	return "Extras/Boolean/Operations"


func _get_description():
	return "Boolean NOT"


func _get_return_icon_type():
	return PORT_TYPE_BOOLEAN


func _get_input_port_count():
	return 1


func _get_input_port_name(port):
	return "a"


func _get_input_port_type(port):
	return PORT_TYPE_BOOLEAN

func _init():
	set_input_port_default_value(0, false)

func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "result"


func _get_output_port_type(port):
	return PORT_TYPE_BOOLEAN


func _get_code(input_vars, output_vars,
		mode, type):
	return output_vars[0] + " = !"+input_vars[0]+";"
