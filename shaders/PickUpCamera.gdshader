shader_type spatial;
render_mode unshaded;

uniform sampler2D ItemCam: filter_nearest;

void vertex() {
	    mat4 modified_model_view = VIEW_MATRIX * mat4(
        INV_VIEW_MATRIX[0],
        INV_VIEW_MATRIX[1],
        INV_VIEW_MATRIX[2],
        MODEL_MATRIX[3]
    );
    MODELVIEW_MATRIX = modified_model_view;
}

void fragment() {
	vec4 ItemCam_color = texture(ItemCam, UV).rgba;
	if (ItemCam_color.a == 1.0) {
		ALBEDO = ItemCam_color.rgb;
	}
	else {
		discard;
		//ALBEDO = WorldCam_color;
	}
	//COLOR = texture(Texture, Texture.uv)
	// Called for every pixel the material is visible on.
}

//void light() {
	// Called for every pixel for every light affecting the material.
	// Uncomment to replace the default light processing function with this one.
//}
