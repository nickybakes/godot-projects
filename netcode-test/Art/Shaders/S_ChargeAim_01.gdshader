shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"

uniform sampler2D mainTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec3 color : source_color = vec3(1, 1, 1);

uniform float colorBlend : hint_range(0.0, 1.0, 0.01) = .8;

uniform float minAlpha : hint_range(0.0, 1.0, 0.01) = .3;
uniform float alphaFadePower = 2.0;
uniform vec2 scrollSpeed;
uniform float emissive = 1.0;

uniform float fresnelPower = 1.0;
uniform float fresnelMultiply = 1.0;
uniform float fresnelAlpha : hint_range(0.0, 1.0, 0.01) = .3;

void fragment() {
	vec4 sampledColor = texture(mainTexture, UV * textureScale + (TIME * scrollSpeed)).rgba;
	
	float fresnel = dot(NORMAL, VIEW);
	fresnel = pow(fresnel, fresnelPower);
	fresnel = fresnel * fresnelMultiply;
	fresnel = clamp(1.0 - fresnel, 0, 1);
	
	float distToEdge = 1.0 - abs(UV.y * 2.0 - .5) * 2.0;
	float calcFade = pow(distToEdge, alphaFadePower);
	calcFade = clamp(calcFade, 0.0, 1.0);
	
	ALBEDO = mix(sampledColor.rgb, color, colorBlend) + color * emissive + fresnel;
	ALPHA = (max(sampledColor.a, minAlpha) + (fresnel * fresnelAlpha)) * calcFade;
}