shader_type canvas_item;

uniform float age : hint_range(0.0, 15.0);

void fragment() {
    // Color: de 0 a 5 segundos pasa de rojo a azul
    float t = clamp(age / 5.0, 0.0, 1.0);
    vec3 hot = vec3(1.0, 0.2, 0.0);
    vec3 cold = vec3(0.2, 0.4, 1.0);
    vec3 base_color = mix(hot, cold, t);

    // Alpha: de 0 a 6s = 1.0, de 6 a 8s baja de 1 a 0, a partir de 8s = 0
    float alpha = 1.0;
    if (age >= 6.0 && age < 8.0) {
        alpha = 1.0 - ((age - 6.0) / 2.0);
    } else if (age >= 8.0) {
        alpha = 0.0;
    }

    COLOR = vec4(base_color, alpha);
}