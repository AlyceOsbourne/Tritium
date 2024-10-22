shader_type canvas_item;

uniform float glow_intensity : hint_range(0.0, 5.0) = 1.0;
uniform vec3 phosphor_color_r = vec3(1.0, 0.2, 0.2);
uniform vec3 phosphor_color_g = vec3(0.2, 1.0, 0.2);
uniform vec3 phosphor_color_b = vec3(0.2, 0.2, 1.0);

uniform float distortion_intensity : hint_range(0.0, 1.0) = 0.3;

uniform float aberration_intensity : hint_range(0.0, 0.05) = 0.01;

uniform float vignette_intensity : hint_range(0.0, 1.0) = 0.7;

uniform float scanline_intensity : hint_range(0.0, 1.0) = 0.5;
uniform float scanline_bandwidth : hint_range(100.0, 1000.0) = 300.0;
uniform int scanline_waveform : hint_enum("Sine", "Sawtooth", "Triangle") = 0;
uniform float scroll_speed : hint_range(0.0, 5.0) = 0.5;
uniform float pulse_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_amplitude : hint_range(0.0, 1.0) = 0.1;
uniform float screen_turn_on_speed : hint_range(0.0, 10.0) = 2.0;
uniform float pulse_brightness_intensity : hint_range(0.0, 10.0) = 5.0;
uniform float initial_pulse_speed : hint_range(0.0, 20.0) = 10.0;

uniform sampler2D SCREEN_TEXTURE : hint_screen_texture, repeat_disable, filter_nearest;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;

    // Barrel Distortion Effect
    uv *= 1.0 + distortion_intensity * length(uv) * length(uv);
    vec2 screen_uv = (uv + 1.0) * 0.5;

    // Chromatic Aberration Effect
    vec2 aberration_offset = aberration_intensity * vec2(length(uv));
    vec4 base_color_r = texture(TEXTURE, UV + aberration_offset);
    vec4 base_color_g = texture(TEXTURE, UV);
    vec4 base_color_b = texture(TEXTURE, UV - aberration_offset);
    vec4 base_color = vec4(base_color_r.r, base_color_g.g, base_color_b.b, base_color_g.a);

    vec4 screen_color = texture(SCREEN_TEXTURE, screen_uv);

    // Calculate luminance to enhance bright areas
    float luminance = dot(screen_color.rgb, vec3(0.299, 0.587, 0.114));

    // Boost glow effect based on luminance
    vec4 glow = vec4(0.0);
    for (int x = -1; x <= 1; x++) {
        for (int y = -1; y <= 1; y++) {
            vec2 offset = vec2(float(x), float(y)) * TEXTURE_PIXEL_SIZE;
            glow += texture(TEXTURE, UV + offset);
        }
    }
    glow /= 9.0;
    glow *= glow_intensity * luminance; // Scale glow by luminance

    // Apply Phosphor Colorization
    vec3 phosphor_color = vec3(
        base_color.r * phosphor_color_r.r + base_color.g * phosphor_color_r.g + base_color.b * phosphor_color_r.b,
        base_color.r * phosphor_color_g.r + base_color.g * phosphor_color_g.g + base_color.b * phosphor_color_g.b,
        base_color.r * phosphor_color_b.r + base_color.g * phosphor_color_b.g + base_color.b * phosphor_color_b.b
    );

    // Scanline Effect with selectable waveform and pulsing bandwidth
    float pulsing_bandwidth = scanline_bandwidth * (1.0 + pulse_amplitude * sin(TIME * pulse_speed));
    float moving_offset = TIME * scroll_speed;
    float scanline = 0.0;
    if (scanline_waveform == 0) {
        scanline = sin((uv.y + moving_offset) * pulsing_bandwidth) * 0.5 + 0.5;
    } else if (scanline_waveform == 1) {
        scanline = fract((uv.y + moving_offset) * pulsing_bandwidth);
    } else if (scanline_waveform == 2) {
        scanline = abs(fract((uv.y + moving_offset) * pulsing_bandwidth) - 0.5) * 2.0;
    }
    scanline = mix(1.0, scanline, scanline_intensity);

    // Screen turn-on effect
    float turn_on_factor = clamp((TIME * screen_turn_on_speed) - length(uv), 0.0, 1.0);
    scanline *= turn_on_factor;

    // Bright Pulse Effect
    float pulse_brightness = 1.0 + pulse_brightness_intensity * abs(sin(TIME * initial_pulse_speed)) * exp(-TIME);

    // Vignette Effect
    float vignette = 1.0 - length(uv) * vignette_intensity;
    vignette = clamp(vignette, 0.0, 1.0);

    // Combine Effects
    vec3 final_color = mix(phosphor_color, screen_color.rgb, 0.5) * pulse_brightness;
    vec4 combined_color = vec4(final_color, base_color.a) * vignette * scanline + glow * vignette;

    // Boost visibility of high luminance objects
    combined_color.rgb += luminance * 0.5; // Adjust to amplify the brightness of high luminance areas

    COLOR = combined_color;
}
