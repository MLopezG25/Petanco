shader_type canvas_item;

uniform float tiempo : hint_range(0.0, 100.0); // CAMBIO: valor que pasas desde GDScript

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);

    // CAMBIO: el color se interpola según el tiempo
    // Empieza en verde y va hacia rojo conforme aumenta "tiempo"
    float factor = clamp(tiempo / 60.0, 0.0, 1.0); // normaliza (0 a 60 seg)
    vec3 start_color = vec3(0.0, 1.0, 0.0); // verde
    vec3 end_color   = vec3(1.0, 0.0, 0.0); // rojo

    vec3 final_color = mix(start_color, end_color, factor);

    COLOR = vec4(final_color, base_color.a);
}
