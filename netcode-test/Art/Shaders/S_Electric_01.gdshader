shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled, depth_prepass_alpha;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"

group_uniforms display;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float colorBrightness = 1.0;
uniform float emissive = 1.0;
uniform float blurMultiply = 1.0;
uniform float blurPower = 1.0;

group_uniforms noiseSample1;
uniform sampler2D noiseTexture : source_color, filter_linear;
uniform vec2 textureScale;
uniform vec2 scrollSpeed;
uniform float noiseDeviation1 = 1.0;

group_uniforms maskSample;
uniform sampler2D maskTexture : source_color, filter_linear;
uniform float maskPower = 1.0;
uniform float maskMultiply = 1.0;
uniform float blurAlphaMultiply = 1.0;
uniform float blurAlphaPower = 1.0;
uniform float alphaThreshold : hint_range(0.0, 1.0, 0.01) = 1.0;


void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 uv1 = UV.xy;
	uv1 = uv1 * textureScale + TIME * scrollSpeed;
	uv1 += COLOR.rg * noiseDeviation1;
	
	vec2 multiSample = texture(noiseTexture, uv1).rg;
	float sample = multiSample.r;
	float blurSample = multiSample.g;
	blurSample = 1.0 - blurSample;
	blurSample = pow(blurSample, blurPower);
	blurSample = blurSample * blurMultiply;
	blurSample = saturate(blurSample);
	blurSample = 1.0 - blurSample;

	float mask = texture(maskTexture, UV).r;
	mask = pow(mask, maskPower) * maskMultiply;
	mask = saturate(mask);
	
	float alpha = mask - (1.0 - sample);
	alpha = alpha - alphaThreshold;
	alpha = saturate(alpha);
	
	float blurAlpha = blurSample;
	blurAlpha = pow(blurAlpha, blurAlphaPower);
	blurAlpha = blurAlpha * blurAlphaMultiply;
	blurAlpha = blurAlpha * mask;
	alpha = alpha + blurAlpha;
	alpha = saturate(alpha);
	
	vec3 finalColor = color;
	finalColor = mix(color, color + colorBrightness, blurSample);
	finalColor = finalColor * emissive;
	
	ALBEDO = finalColor;
	ALPHA = COLOR.a * alpha;
}
