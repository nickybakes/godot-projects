shader_type spatial;
render_mode world_vertex_coords, blend_mix, unshaded, alpha_to_coverage, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"


group_uniforms noiseSample;
uniform sampler2D noiseTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec2 scrollSpeed;
uniform float noiseDistort1 = .3;

group_uniforms alpha;
uniform float alphaMin = .3;
uniform float alphaMax = .3;
uniform float alphaTransitionPower = 1.0;
uniform float alphaTransitionOffset = 0.0;
uniform float alphaThreshold : hint_range(0.0, 1.0, 0.01) = .3;

group_uniforms color;
uniform vec3 innerColor : source_color = vec3(0, 0, 0);
uniform vec3 outerColor : source_color = vec3(1, 1, 1);
uniform float outerThickness = 0.3;
//uniform sampler2D colorTexture : source_color, filter_linear, repeat_disable;
//uniform float colorTransitionPower = 1.0;
//uniform float colorOffset = 0.0;
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
	float transition = 1.0 - max(NORMAL.y, 0);
	float alphaTransition = pow(transition, alphaTransitionPower) + alphaTransitionOffset;
	
	vec2 uv1 = NORMAL.xy;
	uv1 = uv1 * textureScale + TIME * scrollSpeed;
	uv1.x += noiseDistort1 * transition;
	
	float noiseSample = texture(noiseTexture, uv1).r;
	
	float noise = noiseSample;
	float alpha = (1.0 - noise) - mix(1.0 - alphaMax, 1.0 - alphaMin, alphaTransition);	
	alpha = saturate(alpha);	
	
	float maskColor = saturate(smoothstep(alpha, outerThickness, 1.0));

	ALBEDO = mix(innerColor, outerColor, maskColor) * emissive;
	ALPHA = alpha;
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
}