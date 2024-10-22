shader_type canvas_item;

// Colors
uniform vec4 fore_color = vec4(0.5, 0.75, 1.0, 1.0);
uniform vec4 back_color = vec4(1.0, 1.0, 1.0, 1.0);

// Aspect Ratio Adjustment
uniform float aspect_correction = 1.0;

// Grid Size
uniform float grid_scale = 100.0;

// Rotation Angle (in degrees)
uniform float rotation_angle = 45.0;

// Pretty Hip effect parameters
uniform float time_speed = 1.0;
uniform float wave_amplitude = 0.1;
uniform float wave_frequency = 5.0;
uniform float color_shift_speed = 0.5;

// Noise control parameters
uniform float noise_scale = 1.0;
uniform float noise_speed = 1.0;

// Fade-in parameters
uniform float fade_in_duration = 1.0;
uniform float fade_in_delay = 0.5;

float HexDist(vec2 p) {
    p = abs(p);
    return max(dot(p, normalize(vec2(1.0, 1.73))), p.x);
}

vec4 HexCoords(vec2 uv) {
    vec2 r = vec2(1.0, 1.73);
    vec2 h = r * 0.5;
    vec2 a = mod(uv, r) - h;
    vec2 b = mod(uv - h, r) - h;
    vec2 gv = dot(a, a) < dot(b, b) ? a : b;
    float y = 0.5 - HexDist(gv);
    return vec4(atan(gv.x, gv.y), y, uv - gv);
}

vec2 random(vec2 uv) {
    uv = vec2(dot(uv, vec2(127.1, 311.7)),
              dot(uv, vec2(269.5, 183.3)));
    return -1.0 + 2.0 * fract(sin(uv) * 43758.5453123);
}

float noise(vec2 uv) {
    uv *= noise_scale;
    uv += TIME * noise_speed;
    vec2 uv_index = floor(uv);
    vec2 uv_fract = fract(uv);
    vec2 blur = smoothstep(0.0, 1.0, uv_fract);
    return mix(mix(dot(random(uv_index + vec2(0.0, 0.0)), uv_fract - vec2(0.0, 0.0)),
                   dot(random(uv_index + vec2(1.0, 0.0)), uv_fract - vec2(1.0, 0.0)), blur.x),
               mix(dot(random(uv_index + vec2(0.0, 1.0)), uv_fract - vec2(0.0, 1.0)),
                   dot(random(uv_index + vec2(1.0, 1.0)), uv_fract - vec2(1.0, 1.0)), blur.x), blur.y) + 0.5;
}

float stripes(vec2 p, float s) {
    p *= s;
    float n = fract(p.x - p.y * 1.73);
    return (n > 0.75 || n < 0.25) ? 0.5 : 0.25;
}

void fragment() {
    float aspect = aspect_correction * (1.0 / TEXTURE_PIXEL_SIZE).y / (1.0 / TEXTURE_PIXEL_SIZE).x;
    vec2 uv = UV * grid_scale;
    uv -= vec2(0.5, 0.5 * aspect);
    float rot = radians(rotation_angle);
    mat2 m = mat2(vec2(cos(rot), -sin(rot)), vec2(sin(rot), cos(rot)));
    uv = m * uv;
    uv += vec2(0.5, 0.5 * aspect);
    uv.y += 0.5 * (1.0 - aspect);
    uv *= 10.0;

    // Adding Pretty Hip wave effect
    float wave = sin(uv.y * wave_frequency + TIME * time_speed) * wave_amplitude;
    uv.x += wave;

    vec4 hc = HexCoords(uv / 500.0);

    // Shrinking hexes when lit up and adding color shift
    int i = hc.y < 0.05 ? 0 : (hc.y > 0.15 ? 1 : 2);
    float shrink_factor = mix(1.0, 0.5, smoothstep(0.0, 0.15, hc.y));
    float color_shift = 0.5 + 0.5 * sin(TIME * color_shift_speed + hc.zw.x * 10.0);
    vec3 xcol1 = fore_color.rgb * stripes(uv.xy * shrink_factor, 0.005) * noise(hc.zw / 3.0 + TIME) * color_shift;
    vec3 xcol2 = fore_color.rgb * 0.375 * noise(hc.zw / 3.0 + TIME * -1.0) * color_shift;
    vec3 col = i == 0 ? back_color.rgb * 0.125 : (i == 1 ? xcol1 : xcol2);

    // Handling transparency by mixing with alpha values from fore_color and back_color
    float fade_time = clamp((TIME - fade_in_delay) / fade_in_duration, 0.0, 1.0);
    float alpha = mix(back_color.a, fore_color.a, step(0.05, hc.y)) * fade_time;
    COLOR = vec4(col, alpha);
}
