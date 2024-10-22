shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0;
uniform vec4 base_glow_color = vec4(1.0, 0.8, 0.5, 1.0);
uniform float blur_size : hint_range(0.0, 10.0) = 2.0;
uniform float transparency : hint_range(0.0, 1.0) = 0.5; // Transparency level
uniform float glitch_intensity : hint_range(0.0, 1.0) = 0.5; // Intensity of glitch effect
uniform float flicker_speed : hint_range(0.05, 10.0) = 5.0; // Speed of the flicker effect
uniform float flicker_intensity : hint_range(0.0, 1.0) = 0.5; // Intensity of the flicker effect
uniform float fade_in_delay : hint_range(0.0, 5.0) = 1.0; // Delay before fade-in starts

void fragment() {
    vec2 uv = UV;
    vec4 base_color = texture(TEXTURE, uv);

    // Create a broken lamp flicker effect for the glow
    float flicker = step(0.85, fract(sin(TIME * flicker_speed) * 43758.5453)) * (0.6 + 0.4 * sin(TIME * (flicker_speed * 0.25))) * flicker_intensity;
    vec4 dynamic_glow_color = base_glow_color * flicker;

    // Create a glow intensity shift over time for a pulsating effect
    float dynamic_glow_intensity = glow_intensity * flicker;

    vec4 glow = vec4(0.0);
    int blur_range = int(blur_size);

    for (int x = -blur_range; x <= blur_range; x++) {
        for (int y = -blur_range; y <= blur_range; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE;
            glow += texture(TEXTURE, uv + offset);
        }
    }

    glow /= pow(float(blur_range * 2 + 1), 2.0);
    glow = glow * dynamic_glow_color * dynamic_glow_intensity;

    // Apply transparency with fade-in effect
    float fade_in = clamp((TIME - fade_in_delay), 0.0, 1.0); // Fade in over 1 second after delay
    vec4 final_color = base_color + glow;
    final_color.a *= transparency * fade_in;

    // Chromatic aberration effect
    float chroma_offset = 0.01 * glitch_intensity;
    vec4 chroma_r = texture(TEXTURE, uv + vec2(chroma_offset, 0.0));
    vec4 chroma_g = texture(TEXTURE, uv);
    vec4 chroma_b = texture(TEXTURE, uv - vec2(chroma_offset, 0.0));
    vec4 chromatic_aberration = vec4(chroma_r.r, chroma_g.g, chroma_b.b, 1.0);

    // Glitch effect - side-to-side offset synchronized with flicker, modulated by flicker intensity
    float modulated_glitch_intensity = glitch_intensity * flicker * 2.0;
    if (flicker < 0.95) { // Only glitch when flickering
        float glitch_offset = (fract(sin(TIME * 70.0 + uv.y * 200.0) * 98765.4321) - 0.5) * 3.0 * modulated_glitch_intensity;
        uv.x += glitch_offset;
        base_color = texture(TEXTURE, uv);
    }

    // Combine effects
    final_color.rgb = mix(final_color.rgb, chromatic_aberration.rgb, modulated_glitch_intensity);
    COLOR = final_color;
}
