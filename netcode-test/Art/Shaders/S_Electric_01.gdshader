shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, alpha_to_coverage, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"

group_uniforms display;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float emissive = 1.0;


group_uniforms noiseSample1;
uniform sampler2D noiseTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec2 scrollSpeed;
uniform float noiseDeviation1 = 1.0;

group_uniforms noiseSample2;

uniform sampler2D noiseTexture2 : source_color, filter_linear;
uniform vec2 textureScale2;
uniform vec2 scrollSpeed2;
uniform float noiseDeviation2 = 1.0;


group_uniforms maskSample;
uniform sampler2D maskTexture : source_color, filter_linear;
uniform float maskPower = 1.0;
uniform float maskMultiply = 1.0;
uniform float alphaThreshold : hint_range(0.0, 1.0, 0.01) = 1.0;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 uv1 = UV.xy;
	uv1 = uv1 * textureScale + TIME * scrollSpeed;
	uv1 += COLOR.rg * noiseDeviation1;
	
	float sample = texture(noiseTexture, uv1).r;

	float mask = texture(maskTexture, UV).r;
	mask = pow(mask, maskPower) * maskMultiply;
	mask = saturate(mask);
	
	float alpha = mask - (1.0 - sample);	
	alpha = saturate(alpha);	

	ALBEDO = color * emissive;
	ALPHA = COLOR.a * alpha;
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
}
