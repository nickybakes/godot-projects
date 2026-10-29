shader_type spatial;
render_mode blend_mix, unshaded;
#include "SI_Util_01.gdshaderinc"

uniform sampler2D fgTexture : source_color, filter_linear;
uniform sampler2D bgTexture : source_color, filter_linear;
uniform vec2 textureScale1;
uniform vec2 textureScroll1;
uniform vec2 textureScale2;
uniform vec2 textureScroll2;
uniform float emissive = 1.0;

void fragment() {
	vec4 fg = texture(fgTexture, UV * textureScale1 + (TIME * textureScroll1)).rgba;
	vec3 bg = texture(bgTexture, UV * textureScale2 + (TIME * textureScroll2)).rgb;
	
	vec3 color = mix(bg.rgb, fg.rgb, fg.a) * emissive;
	
	ALBEDO = color;
}