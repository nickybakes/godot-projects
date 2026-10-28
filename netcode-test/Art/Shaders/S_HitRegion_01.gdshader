shader_type spatial;
render_mode unshaded, depth_prepass_alpha;
#include "SI_Tone_01.gdshaderinc"

uniform vec3 color : source_color = vec3(1, 1, 1);
uniform float brightness : hint_range(0.0, 1.0, 0.01) = .25;
uniform float fresnelPower = 1.0;
uniform float fresnelMultiply = 1.0;
uniform float alpha : hint_range(0.0, 1.0, 0.01) = 1.0;

void fragment() {
	float value = pow(dot(NORMAL, VIEW), fresnelPower) * fresnelMultiply;
	vec2 tone = tone(VERTEX);
	ALPHA = (.5 * (clamp(trunc(value + tone.y), 0.0, 1.0)) * 2.0) * alpha;
	ALBEDO = color * brightness;
}
