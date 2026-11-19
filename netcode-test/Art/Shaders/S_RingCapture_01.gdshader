shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled;

#include "SI_Util_01.gdshaderinc"

uniform sampler2D colorTexture : filter_linear_mipmap;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform vec2 textureScroll;
uniform vec2 textureScale;

uniform float scanlineScale = 1.0;
uniform float scanlineTimeScale = 1.0;
uniform float scanlineAlpha : hint_range(0.0, 1.0, 0.01) = .75;
uniform float minAlpha : hint_range(0.0, 1.0, 0.01) = .15;

uniform float heightArray[32];
uniform float distanceThreshold = 5.0;
uniform float arraySplit = 0.08333;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	vec2 uvs = vec2(0, WORLD_POS.y);
	uvs *= textureScale;
	uvs += TIME * textureScroll;
	
	vec3 textureSample = texture(colorTexture, uvs).rgb;
	
	float sinValue = sin((TIME * scanlineTimeScale) + (WORLD_POS.y * scanlineScale));
	sinValue = sinValue * sinValue;
	sinValue = saturate(sinValue);
	
	int index0 = 0;
	int index1 = 1;
	
	index0 = int(min(UV.x, .99)/arraySplit);
	index1 = (index0 + 1) % heightArray.length();
	
	float t = (UV.x - (float(index0) * arraySplit))/arraySplit;
	float calcHeight = mix(heightArray[index0], heightArray[index1], t);
	
	float alpha = abs(WORLD_POS.y - calcHeight) + 1.0 - distanceThreshold;
	alpha = saturate(alpha);
	alpha = 1.0 - alpha;
	alpha = alpha * mix(minAlpha, scanlineAlpha, sinValue);
	
	ALBEDO = color * textureSample;
	ALPHA = alpha;
}
