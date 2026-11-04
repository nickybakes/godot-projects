shader_type spatial;
render_mode blend_mix, unshaded;

uniform sampler2D alphaTexture : source_color, filter_linear, repeat_disable;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float emissive = 1.0;

uniform float uvScale = 1.0;
uniform float uvOffset = 0.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec2 customUV = UV;
	customUV.y += uvOffset; 
	customUV.y *= uvScale; 
	float alpha = texture(alphaTexture, customUV).r;
	ALBEDO = color * emissive;
	ALPHA = alpha;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
