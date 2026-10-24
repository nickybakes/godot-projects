shader_type spatial;

uniform sampler2D mainTexture : source_color, filter_linear;
uniform float textureScale = 1;
uniform vec3 color : source_color = vec3(1, 1, 1);

uniform float emissive : hint_range(1.0, 10.0, .01) = 1;
uniform float roughness : hint_range(0.0, 1.0, .01) = .5;
uniform float metallic : hint_range(0.0, 1.0, .01) = .5;

uniform float fresnelPower = 1.0;
uniform float fresnelMultiply = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 sampledColor = texture(mainTexture, UV * textureScale).rgb;
	float fresnel = dot(NORMAL, VIEW);
	
	fresnel = pow(fresnel, fresnelPower);
	fresnel = fresnel * fresnelMultiply;
	fresnel = clamp(1.0 - fresnel, 0, 1);
	
	ALBEDO = sampledColor * color * emissive + fresnel;
	ROUGHNESS = roughness;
	METALLIC = metallic;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
