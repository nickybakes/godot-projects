shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled;

#include "SI_Util_01.gdshaderinc"

global uniform float ringRadius;

uniform sampler2D depth_texture : hint_depth_texture, repeat_disable, filter_nearest;

uniform sampler2D colorTexture : filter_linear_mipmap;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float colorToTextureMix : hint_range(0.0, 1.0, .01) = 0.0;
uniform float emissive = 1.0;
uniform vec2 textureScroll;
uniform vec2 textureScale;
uniform float distanceThreshold = 5.0;

group_uniforms details;
uniform sampler2D detailTexture : source_color, filter_linear;
uniform float ringRadiusUVScale = 10.0;
uniform vec2 detailTextureScale;
uniform vec2 detailTextureScale2;
uniform vec2 detailScrollSpeed;
uniform vec2 detailScrollSpeed2;
uniform float detailAlphaPower = 1.0;
uniform float detailAlphaMultiply = 1.0;

group_uniforms scanline;
uniform float scanlineScale = 1.0;
uniform float scanlineTimeScale = 1.0;
uniform float scanlineAlpha : hint_range(0.0, 1.0, 0.01) = .75;
uniform float minAlpha : hint_range(0.0, 1.0, 0.01) = .15;

group_uniforms depth;
uniform vec3 depthColor : source_color = vec3(1, 1, 1);
uniform float depthEmissive = 1.0;
uniform float depthMultiply = .4;
uniform float depthPower = .6;
uniform float depthAlpha = 1.0;

group_uniforms height;
uniform float heightArray[32];
uniform float arraySplit = 0.1;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	// Get the raw linear depth from the depth texture into a  [-1, 1] range
    float depth = textureLod(depth_texture, SCREEN_UV, 0.0).r;	
	// Recreate linear depth of the intersecting geometry using projection matrix, and subtract the vertex of the sphere
	depth = PROJECTION_MATRIX[3][2] / (depth + PROJECTION_MATRIX[2][2]) + VERTEX.z;
	// Intensity intersection effect
	depth = 1.0 - saturate(pow(depth * depthMultiply, depthPower));
	
	int index0 = 0;
	int index1 = 1;
	
	index0 = int(min(UV.x, .99)/arraySplit);
	index1 = (index0 + 1) % heightArray.length();
	
	float t = (UV.x - (float(index0) * arraySplit))/arraySplit;
	float calcHeight = mix(heightArray[index0], heightArray[index1], t);
	float diff = WORLD_POS.y - calcHeight;
	
	vec2 uvs = vec2(0, diff);
	
	uvs *= textureScale;
	uvs += TIME * textureScroll;
	
	
	vec3 textureSample = texture(colorTexture, uvs).rgb;
	
	float sinValue = sin((TIME * scanlineTimeScale) + (diff * scanlineScale));
	sinValue = sinValue * sinValue;
	sinValue = saturate(sinValue);
	
	float dist = diff + 1.0 - distanceThreshold;
	
	vec3 finalColor = mix(textureSample, color, colorToTextureMix) * emissive;
	finalColor = mix(finalColor, depthColor * depthEmissive, depth);
	
	vec2 detailUVs = UV;
	detailUVs.x *= ringRadius * ringRadiusUVScale;
	detailUVs.y = WORLD_POS.y;
	
	float sampledAlpha = texture(detailTexture, detailUVs * detailTextureScale + (TIME * detailScrollSpeed)).r;
	sampledAlpha += texture(detailTexture, detailUVs * detailTextureScale2 + (TIME * detailScrollSpeed2)).r;
	
	sampledAlpha = saturate(sampledAlpha);
	
	
	float alpha = dist;
	alpha = saturate(alpha);
	alpha = 1.0 - alpha;
	float clipAlpha = alpha;
	
	alpha = (pow(clipAlpha, detailAlphaPower) * detailAlphaMultiply) - sampledAlpha;
	
	alpha = saturate(alpha);
	//alpha = alpha * mix(minAlpha, scanlineAlpha, sinValue);
	alpha = mix(alpha, depthAlpha, depth);
	
	ALBEDO = finalColor;
	ALPHA = alpha;
}
