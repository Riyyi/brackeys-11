shader_type spatial;
render_mode unshaded;

uniform sampler2D GunCam: filter_nearest;

void vertex() {
	POSITION = vec4(VERTEX, 1.0);
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 GunCam_color = texture(GunCam, SCREEN_UV).rgba;
	if (GunCam_color.a == 1.0) {
		ALBEDO = GunCam_color.rgb;
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
