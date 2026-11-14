shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled;
#include "SI_Util_01.gdshaderinc"
#include "SI_Fire_01.gdshaderinc"


uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

group_uniforms display;
uniform sampler2D fireNoiseTexture : filter_linear_mipmap;
uniform vec3 innerColor : source_color = vec3(0, 0, 0);
uniform vec3 outerColor : source_color = vec3(1, 1, 1);
uniform vec2 textureScroll;
uniform vec2 textureScale;
uniform float ringRadiusUVScale = 10.0;
uniform float outerThickness = 0.3;

group_uniforms distortion;
uniform vec2 distortAmount;
uniform float distortTimeScale = 5.0;
uniform float distortYScale = 5.0;

group_uniforms depth;
uniform float depthMultiply = .4;
uniform float depthPower = .6;
uniform float fadeAwayDistance = 2.0;

group_uniforms alpha;
uniform float alphaMultiply = 1.0;
uniform float alphaThreshold = .1;

void vertex() {
    VERTEX.xz = normalize(INV_VIEW_MATRIX[0].xz) * VERTEX.x + normalize(INV_VIEW_MATRIX[2].xz) * VERTEX.z;
    VERTEX.y = VERTEX.y;
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	// Get the raw linear depth from the depth texture into a  [-1, 1] range
    float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;
	// Recreate linear depth of the intersecting geometry using projection matrix, and subtract the vertex of the sphere
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	// Intensity intersection effect
	depth = 1.0 - saturate(pow(depth * depthMultiply, depthPower));
	
	float distortSin = timeSin(TIME, UV.y * distortYScale, distortTimeScale);
	float UVx = WORLD_POS.x + WORLD_POS.z;
	UVx += distortSin * distortAmount.x;
	UVx += TIME * textureScroll.x;
	
	float UVy = WORLD_POS.y;
	UVy -= TIME * textureScroll.y;
	UVy += distortSin * distortAmount.y;

	float noiseSample = texture(fireNoiseTexture, vec2(UVx, UVy) * textureScale).r;
	
	float UVmask = (1.0 - abs(2.0 * UV.x - 1.0)) * UV.y;
	float emberMask = UVmask * COLOR.r * alphaMultiply;
	float maskColor = saturate(smoothstep(emberMask - noiseSample - depth, outerThickness, 1.0));

	ALBEDO = mix(innerColor, outerColor, maskColor);

	//ALBEDO = vec3(distortSin);
	float fadeAway = saturate(fadeAwayDistance - abs(VERTEX.z));
	ALPHA = saturate(1.0 - smoothstep(emberMask - noiseSample - depth - fadeAway, alphaThreshold, 1.0));
	ALPHA_SCISSOR_THRESHOLD = alphaThreshold;
	//ALBEDO = vec3(emberMask);

}