shader_type spatial;

varying vec3 pos;
void vertex() {
	pos = mat3(MODEL_MATRIX) * -VERTEX;
	pos = pos - NODE_POSITION_WORLD;
	pos = pos + vec3(10.0,10.0,10.0);
	pos = pos*0.019;
}

void fragment() {
	vec3 falb = vec3(0.03,0.13,0.0);
	vec3 nalb = vec3(0.1,0.1,0.2);
	if (pos.y < 1.0) {
		if (pos.y > 0.0) {
			ALBEDO = falb;
		}
		else if (pos.y >= -1.0){
			nalb *= ((-1.0)*pos.y);
			falb *= (vec3(1.0,1.0,1.0)-((-1.0)*pos.y));
			ALBEDO = nalb+falb;
		}
		else if (pos.y >= -2.0){
			ALBEDO = nalb;
		}
		else if (pos.y >= -3.0){
			ALBEDO = nalb * (1.0 + (3.0*((-1.0)*(2.0+pos.y))));
		}
	}
}