shader_type spatial;



uniform sampler2D normalmap_tex: repeat_enable, filter_linear;

uniform sampler2D normalmap_tex2: repeat_enable, filter_linear;

uniform vec3 albedo: source_color;

uniform vec2 direction1 = vec2(1.0,0.0);

uniform float speed: hint_range(0.0, 1.0) = 0.1;

uniform vec2 direction2 = vec2(1.0,0.0);

uniform float speed2: hint_range(0.0, 1.0) = 0.1;



void fragment(){

	vec2 offset1 = speed * direction1 * TIME;

	vec2 offset2 = speed2 * direction2 * TIME;

	vec3 normal = texture(normalmap_tex, UV + offset1).rbg;

	vec3 normal2 = texture(normalmap_tex2, UV + offset2).rbg;

	vec3 final_normal = mix(normal, normal2, 0.5);

	NORMAL_MAP = final_normal;



	METALLIC = 0.0;

	ALBEDO = albedo;

	ROUGHNESS = 0.01;

}