@tool
class_name VisualShaderNodeBackgroundBlur
extends VisualShaderNodeCustom


func _get_name():
	return "BackgroundBlur"


func _get_category():
	return "Extras/Effects"


func _get_description():
	return "Blurs the Background Radially"


func _get_return_icon_type():
	return PORT_TYPE_VECTOR_3D


func _get_input_port_count():
	return 4


func _get_input_port_name(port):
	return [
			"Use Relative Blur Size",
			"Percent Size",
			"Pixel Size",
			"Blur Iterations"
	][port]


func _get_input_port_type(port):
	return [
			PORT_TYPE_BOOLEAN,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR,
			PORT_TYPE_SCALAR_UINT
	][port]

func _init():
	set_input_port_default_value(0, true)  # Use Relative Blur Size
	set_input_port_default_value(1, 10.0)  # Percent Blur
	set_input_port_default_value(2, 50.0)  # Pixel Blur
	set_input_port_default_value(3, 16)    # Blur Iterations

func _get_output_port_count():
	return 1


func _get_output_port_name(port):
	return "Blurred Background"


func _get_output_port_type(port):
	return PORT_TYPE_VECTOR_3D

func _get_global_code(mode):
	return "uniform sampler2D ScreenTexture : hint_screen_texture;"

func _get_code(input_vars, output_vars, mode, type):
	var relative_str = input_vars[0]
	var percent_str = input_vars[1]
	var pixel_str = input_vars[2]
	var iter_str = input_vars[3]
	
	var blurred_str = output_vars[0]
	return """
	{BlurredBackground} = texture(ScreenTexture,SCREEN_UV).rgb;
	uint pixel_area = 1u;
	vec2 blur_size = {UseRelative}? vec2({PercentSize})/100.0*max(1.0/SCREEN_PIXEL_SIZE.y,1.0/SCREEN_PIXEL_SIZE.x)*SCREEN_PIXEL_SIZE : SCREEN_PIXEL_SIZE*{PixelSize};
	for(uint ix = 0u; ix < {Iterations}; ix++){
		for(uint iy = 0u; iy < {Iterations}; iy++){
			vec2 sample_vector = 2.0*vec2(float(ix),float(iy))/float({Iterations})-vec2(1.0);
			if(length(sample_vector) > 1.0){continue;}
			vec2 sample_uv = sample_vector*blur_size+SCREEN_UV;
			{BlurredBackground} += texture(ScreenTexture,sample_uv).rgb;
			pixel_area += 1u;
		}
	}
	{BlurredBackground} /= float(pixel_area);
	""".format({
		"BlurredBackground":blurred_str,
		"UseRelative":relative_str,
		"PercentSize":percent_str,
		"PixelSize":pixel_str,
		"Iterations":iter_str
	})
