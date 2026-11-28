shader_type canvas_item;

uniform float scroll_speed = 0.1;

void fragment() {
	vec2 scrolled_uv = vec2(UV.x, fract(UV.y + TIME * scroll_speed));
	COLOR = texture(TEXTURE, scrolled_uv);
}
