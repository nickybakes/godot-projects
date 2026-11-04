shader_type spatial;
render_mode blend_mix, unshaded, depth_draw_never, depth_test_disabled;
#include "SI_Util_01.gdshaderinc"

uniform sampler2D sampleTexture : source_color, filter_linear, repeat_disable;

group_uniforms color;
uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float emissive = 1.0;
uniform float brightness = 0.0;
uniform float brightnessMask = 0.0;

group_uniforms alpha;
uniform float edgeAlpha : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float midAlpha : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float alphaEdge = 1.0;
uniform float alphaEdgePower = 1.0;
uniform float alphaMultiply = 1.0;


group_uniforms heartbeat;
uniform float heartbeatFade : hint_range(0.0, 1.0, 0.01) = 1.0;
uniform float heartbeatAmount = 0.0;
uniform float heartbeatSpeed = 1.0;
uniform float heartbeatScale = 1.0;
uniform float heartbeatEdge = 1.0;
uniform float heartbeatOffset = 1.0;
uniform float heartbeatOffSpeed = 1.0;
uniform float heartbeatOffScale = 1.0;

void vertex() {
	float offset = sin((COLOR.y * heartbeatScale) + TIME * heartbeatSpeed);
	offset += cos((COLOR.y * heartbeatOffScale + heartbeatOffset) + TIME * heartbeatOffSpeed);
	float distToEdge = 1.0 - (abs(UV.y - .5) * 2.0);
	offset *= pow(distToEdge, heartbeatEdge) * heartbeatAmount * heartbeatFade;
	VERTEX.x += offset;
}

void fragment() {
	float sample = texture(sampleTexture, UV).r;
	float brightMask = saturate(sample - brightnessMask);
	ALBEDO = mix(color, color + brightness, brightMask) * emissive;
	
	float distToEdge = 1.0 - (abs(UV.y - .5) * 2.0);
	
	float alphaBlendMask;
	alphaBlendMask = saturate(distToEdge - alphaEdge);
	alphaBlendMask = (1.0 - alphaBlendMask) * alphaEdgePower;
	alphaBlendMask = saturate(alphaBlendMask);
	float alpha = mix(edgeAlpha, midAlpha, 1.0 - alphaBlendMask);
	ALPHA = sample * alpha * alphaMultiply;
}
