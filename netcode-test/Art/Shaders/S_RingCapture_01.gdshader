shader_type spatial;
render_mode blend_mix, unshaded, cull_disabled;

#include "SI_Util_01.gdshaderinc"

uniform vec3 color : source_color = vec3(1, 1, 1);

uniform float heightArray[32];
uniform float distanceThreshold = 5.0;
uniform float arraySplit = 0.08333;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 WORLD_POS = (INV_VIEW_MATRIX * vec4(VERTEX, 1.0)).xyz;
	
	int index0 = 0;
	int index1 = 1;
	
	index0 = int(min(UV.x, .99)/arraySplit);
	index1 = (index0 + 1) % heightArray.length();
	
	float t = (UV.x - (float(index0) * arraySplit))/arraySplit;
	float calcHeight = mix(heightArray[index0], heightArray[index1], t);
	
	float alpha = abs(WORLD_POS.y - calcHeight) + 1.0 - distanceThreshold;
	alpha = saturate(alpha);
	alpha = 1.0 - alpha;
	
	ALBEDO = color;
	ALPHA = alpha;
}
