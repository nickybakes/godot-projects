shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"


group_uniforms display;
uniform sampler2D fireNoiseTexture : filter_linear_mipmap;
uniform vec3 innerColor : source_color = vec3(0, 0, 0);
uniform vec3 outerColor : source_color = vec3(1, 1, 1);
uniform vec2 textureScroll;
uniform vec2 textureScale;
uniform float ringRadiusUVScale = 10.0;
uniform float outerThickness = 0.3;
uniform float noiseDeviation1 = 1.0;

group_uniforms distortion;
uniform vec2 distortAmount;
uniform float distortTimeScale;
uniform float distortYPower;
uniform float distortYScale;

group_uniforms alpha;
uniform float alphaMultiply = 1.0;
uniform float alphaThreshold = .1;

void vertex(){
	float distortSin = timeSin((UV.y * distortYScale) + COLOR.r, TIME, distortTimeScale);
	VERTEX.x += distortSin * distortAmount.x * saturate(pow(1.0 - UV.y, distortYPower));
}

void fragment() {
	vec2 uv1 = UV.xy;
	uv1 = uv1 * textureScale + TIME * textureScroll;
	uv1 += COLOR.rg * noiseDeviation1;
	uv1.x += (distortAmount.x * UV.y);
	
	uv1.y += TIME * textureScroll.y;
	uv1.y += (distortAmount.y * UV.y);

	float noiseSample = texture(fireNoiseTexture, uv1 * textureScale).r;
	
	float UVmask = (1.0 - abs(2.0 * UV.x - 1.0)) * UV.y;
	float emberMask = UVmask * alphaMultiply;
	float maskColor = saturate(smoothstep(emberMask - noiseSample, outerThickness, 1.0));

	ALBEDO = mix(innerColor, outerColor, maskColor);

	ALPHA = saturate(1.0 - smoothstep(emberMask - noiseSample, alphaThreshold, 1.0));
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
	//ALBEDO = vec3(emberMask);

}