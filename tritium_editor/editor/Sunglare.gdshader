shader_type canvas_item;

uniform float glare_radius : hint_range(0.0, 1.0) = 0.5;
uniform float shadow_intensity : hint_range(0.0, 1.0) = 0.5;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec2 uv = UV;
    vec2 dir = uv - vec2(1, 0);
    float dist = length(dir);

    // Glare effect with a bright center that gradually fades out
    float glare = smoothstep(glare_radius, 0.0, dist) * 0.4;

    // Shadow effect focused on the right and top edges, to give an inset look
    float shadow = smoothstep(0.0, glare_radius, dist) * shadow_intensity * step(0.0, dot(dir, vec2(1.0, 1.0)));

    // Final color with glare and shadow effects
    vec4 base_color = texture(SCREEN_TEXTURE, uv);
    vec3 final_color = base_color.rgb + vec3(glare) - vec3(shadow);
    COLOR = vec4(final_color, base_color.a);
}
