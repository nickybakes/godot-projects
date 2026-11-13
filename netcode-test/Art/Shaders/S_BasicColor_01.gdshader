shader_type spatial;
render_mode unshaded;

uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float alpha : hint_range(0.0, 1.0, .01) = .01;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	ALBEDO = color;
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
