shader_type spatial;
render_mode blend_mix, unshaded, cull_front, depth_draw_never;

uniform vec3 color : source_color = vec3(0, 0, 0);
uniform float brightness : hint_range(0.0, 1.0, 0.01) = 0;
uniform float outlineThickness = .1;

void vertex(){
	VERTEX += normalize(NORMAL) * outlineThickness;
}

void fragment() {
	ALBEDO = color * brightness;
}