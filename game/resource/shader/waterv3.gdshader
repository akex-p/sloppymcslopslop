shader_type spatial;

render_mode blend_mix, cull_back, depth_draw_never;

uniform vec4 primary_color : source_color;
uniform vec4 secondary_color : source_color;
uniform float roughness = 0.2;

// Depth
uniform float depth_distance : hint_range(0.0, 20.0, 0.1) = 4.0;
uniform float beers_law : hint_range(0.0, 20.0, 0.1) = 4.0;

// This mixes in the screen texture.
// Higher = clearer / more see-through-looking.
uniform float water_transparency : hint_range(0.0, 1.0, 0.01) = 0.75;

// Actual material transparency.
// Lower = more transparent.
uniform float alpha_amount : hint_range(0.0, 1.0, 0.01) = 0.25;

uniform sampler2D depth_texture : hint_depth_texture;
uniform sampler2D screen_texture : hint_screen_texture;

float fresnel(float amount, vec3 normal, vec3 view) {
	return pow(
		1.0 - clamp(dot(normalize(normal), normalize(view)), 0.0, 1.0),
		amount
	);
}

void vertex() {
}

void fragment() {
	float basic_fresnel = fresnel(3.0, NORMAL, VIEW);

	vec2 screen_uv = clamp(SCREEN_UV, vec2(0.001), vec2(0.999));

	float depth = textureLod(depth_texture, screen_uv, 0.0).r;
	vec3 screen = textureLod(screen_texture, screen_uv, 0.0).rgb;

	// Reconstruct the view-space position of whatever is behind the water.
	vec3 ndc = vec3(screen_uv * 2.0 - 1.0, depth);
	vec4 scene_view = INV_PROJECTION_MATRIX * vec4(ndc, 1.0);
	scene_view.xyz /= scene_view.w;

	// In view space, the camera looks down -Z.
	// VERTEX.z is the water surface depth.
	// scene_view.z is the depth of the object behind it.
	float water_distance = -VERTEX.z;
	float scene_distance = -scene_view.z;

	// How much water is between the front face of the cube and the thing behind it.
	float depth_amount = max(scene_distance - water_distance, 0.0);

	float depth_blend = clamp(depth_amount / depth_distance, 0.0, 1.0);

	// Beer-Lambert style fade.
	depth_blend = exp(-depth_blend * beers_law);

	vec3 depth_color = mix(secondary_color.rgb, primary_color.rgb, depth_blend);

	// Make the side mostly show the screen behind it, with water tint.
	vec3 final_color = mix(depth_color, screen, water_transparency);

	// Fresnel makes grazing angles a little more reflective/solid.
	float fresnel_amount = basic_fresnel * 0.35;

	ALBEDO = mix(final_color, screen, fresnel_amount);

	// Real transparency.
	ALPHA = alpha_amount;

	ROUGHNESS = roughness * (1.0 - basic_fresnel);
}