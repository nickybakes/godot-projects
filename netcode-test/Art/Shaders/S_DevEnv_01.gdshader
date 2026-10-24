shader_type spatial;

#include "SI_Util_01.gdshaderinc"

uniform sampler2D devTexture : source_color, filter_nearest;

uniform float textureScale = 1.5;
uniform float roughness : hint_range(0.0, 1.0, .01) = .75;
uniform float roughnessAdjust : hint_range(0.0, 1.0, .01) = .75;
uniform float metallic : hint_range(0.0, 1.0, .01) = .25;

uniform float brightness : hint_range(0.0, 1.0, .01) = 1.0;
uniform float saturation : hint_range(0.0, 1.0, .01) = 1.0;

void vertex() {
	COLOR.r = map(cos(NODE_POSITION_WORLD.x * 5.0), 0.0, 1.0, .4, .8);
	COLOR.g = map(sin(NODE_POSITION_WORLD.y * 5.0), 0.0, 1.0, .5, .8);
	COLOR.b = map(sin(NODE_POSITION_WORLD.z * 5.0), 0.0, 1.0, .4, .8);
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	vec3 WORLD_NORMAL = (INV_VIEW_MATRIX * vec4(normalize(NORMAL), 0.0)).xyz;
	vec3 absNormal = abs(WORLD_NORMAL);
	vec3 blendWeights = pow(absNormal, vec3(100.0));
	blendWeights = normalize(blendWeights);
	vec2 WORLD_UV = (blendWeights.x * WORLD_POS.yz) + (blendWeights.y * WORLD_POS.xz) + (blendWeights.z * WORLD_POS.xy);
	
	float sampledValue = texture(devTexture, WORLD_UV * textureScale).r;
	vec3 adjustedColor = mix(COLOR.rgb, vec3(sampledValue), 1.0 - saturation) * brightness;
	
	vec3 sampledColor = adjustedColor * sampledValue;
	
	ALBEDO = sampledColor;
	ROUGHNESS = roughness * clamp(sampledValue + roughnessAdjust, 0, 1);
	METALLIC = metallic;
}
