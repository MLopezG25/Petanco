shader_type canvas_item;

uniform float age : hint_range(0.0, 15.0);

void fragment() {
    // Color blanco con valores > 1.0 para activar glow
    vec3 base_color = vec3(30); // blanco brillante

    // Opacidad: 1.0 hasta 4s, luego baja linealmente hasta 0 en 6s
   // float alpha = 1.0;
  //  if (age >= 4.0 && age < 6.0) {
  //      alpha = 1.0 - (age - 1);
//    } else if (age >= 6.0) {
  //      alpha = 0.0;
 //   }
//    COLOR = vec4(base_color, alpha);
}