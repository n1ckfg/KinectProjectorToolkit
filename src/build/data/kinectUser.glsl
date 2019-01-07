#define PROCESSING_TEXTURE_SHADER

uniform sampler2D texture;
uniform vec2 resolution;

void main(void) {
	vec2 p = gl_FragCoord.xy / resolution.xy;
	p.y = 1.0 - p.y;
	vec3 col = texture2D(texture, p).rgb;
	float d = abs(col.r - col.g) + abs(col.r - col.b);
	vec3 col2 = mix(vec3(0.0), col, step(0.01, d));
	gl_FragColor = vec4(col2, 1.0);
}