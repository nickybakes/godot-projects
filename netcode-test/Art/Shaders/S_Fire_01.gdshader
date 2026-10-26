shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, alpha_to_coverage, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"


group_uniforms noiseSample;
uniform sampler2D noiseTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec2 textureScale2;
uniform vec2 scrollSpeed;
uniform vec2 scrollSpeed2;
uniform float noiseDistort1 = .3;
uniform float noiseDistort2 = .3;

group_uniforms alpha;
uniform float alphaMin = .3;
uniform float alphaMax = .3;
uniform float alphaTransitionPower = 1.0;
uniform float alphaTransitionOffset = 0.0;
uniform float alphaThreshold : hint_range(0.0, 1.0, 0.01) = .3;

group_uniforms color;
uniform sampler2D colorTexture : source_color, filter_linear, repeat_disable;
uniform float colorTransitionPower = 1.0;
uniform float colorOffset = 0.0;
uniform float emissive = 1.0;

group_uniforms distortion;
uniform vec2 distortAmount; 
uniform vec2 distortPower;
uniform vec2 distortFrequency; 
uniform float distortTimeScale;
uniform vec3 distortSpeed; 
uniform vec3 distortTimeOffset; 
uniform vec2 distortMin;

void vertex() {
	float transition = (NORMAL.y + 1.0) * .5;
	float tx = saturate(pow(transition, distortPower.x));
	float ty = saturate(pow(transition, distortPower.y));
	float time = TIME * distortTimeScale;
	
	VERTEX.x += NORMAL.x * fireDistortDelta(tx, distortFrequency.x, distortAmount.x, distortMin.x, time + distortTimeOffset.x, distortSpeed.x);
		
	VERTEX.y += NORMAL.y * distortAmount.y * ty;
	
	VERTEX.z += NORMAL.z * fireDistortDelta(tx, distortFrequency.x, distortAmount.x, distortMin.x, time + distortTimeOffset.z, distortSpeed.z);
}

void fragment() {
	vec3 WORLD_NORMAL = (INV_VIEW_MATRIX * vec4(normalize(NORMAL), 0.0)).xyz;
	float transition = 1.0 - UV.y;
	float alphaTransition = pow(transition, alphaTransitionPower) + alphaTransitionOffset;
	float colorTransition = pow(transition, colorTransitionPower) + colorOffset;
	
	vec2 uv1 = UV.xy;
	uv1 = uv1 * textureScale + TIME * scrollSpeed;
	uv1.x += noiseDistort1 * transition;
	
	vec2 uv2 = UV.yx;
	uv2 = uv2 * textureScale2 + TIME * scrollSpeed2;
	uv2.x += noiseDistort2 * transition;
	
	float noiseSample = texture(noiseTexture, uv1).r;
	float noiseSample2 = texture(noiseTexture, uv2).r;
	
	float noise = noiseSample + noiseSample2;
	//noise = noiseSample;
	float alpha = (1.0 - noise) - mix(1.0 - alphaMax, 1.0 - alphaMin, alphaTransition);	
	alpha = clamp(alpha, 0.0, 1.0);	
	
	vec3 color = texture(colorTexture, vec2(colorTransition, 0.0)).rgb;
	
	ALBEDO = color + (color * color * emissive);
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
}