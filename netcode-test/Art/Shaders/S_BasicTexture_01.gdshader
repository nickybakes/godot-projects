shader_type spatial;
render_mode unshaded;

uniform sampler2D mainTexture : filter_linear_mipmap;
uniform float emissive = 1.0;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float alpha : hint_range(0.0, 1.0, .01) = .01;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec4 sample = texture(mainTexture, UV);
	ALBEDO = sample.rgb * color * emissive;
	ALPHA = sample.a * alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
