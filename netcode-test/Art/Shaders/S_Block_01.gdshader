shader_type spatial;
render_mode blend_mix, cull_disabled, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"

uniform sampler2D mainTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec2 textureScale2;
uniform vec2 scrollSpeed;
uniform vec2 scrollSpeed2;

uniform vec3 color : source_color = vec3(1, 1, 1);

uniform float textureAlpha : hint_range(0.0, 1.0, 0.01) = .3;

uniform float minAlpha : hint_range(0.0, 1.0, 0.01) = .3;
uniform float alphaFadePower = 2.0;
uniform float emissive = 1.0;

uniform float roughness : hint_range(0.0, 1.0, 0.01) = .3;
uniform float metallic : hint_range(0.0, 1.0, 0.01) = .3;

uniform float highlightPower = 1.0;
uniform float highlightMultiply = 1.0;
uniform float highlightAlpha : hint_range(0.0, 1.0, 0.01) = .3;

uniform float fresnelPower = 1.0;
uniform float fresnelMultiply = 1.0;
uniform float fresnelAlpha : hint_range(0.0, 1.0, 0.01) = .3;


void fragment() {
	float sampledAlpha = texture(mainTexture, UV * textureScale + (TIME * scrollSpeed)).a;
	sampledAlpha += texture(mainTexture, UV * textureScale2 + (TIME * scrollSpeed2)).a;
	
	float fresnel = dot(NORMAL, VIEW);
	fresnel = pow(fresnel, fresnelPower);
	fresnel = fresnel * fresnelMultiply;
	fresnel = clamp(1.0 - fresnel, 0, 1);
	
	float highlight = dot(NORMAL, VIEW);
	highlight = pow(highlight, highlightPower);
	highlight = highlight * highlightMultiply;
	highlight = clamp(highlight, 0, 1);
	
	float distToEdge = 1.0 - abs(UV.y * 2.0 - .5) * 2.0;
	float calcFade = pow(distToEdge, alphaFadePower);
	calcFade = clamp(calcFade, 0.0, 1.0);
	
	ROUGHNESS = roughness;
	METALLIC = metallic;
	ALBEDO = (color + fresnel + highlight) * emissive;
	ALPHA = min(1.0, minAlpha + (sampledAlpha * textureAlpha) + (fresnel * fresnelAlpha) + (highlight * highlightAlpha));
}