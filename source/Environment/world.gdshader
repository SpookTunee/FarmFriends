shader_type spatial;

varying vec3 pos;
void vertex() {
    pos = mat3(MODEL_MATRIX) * -VERTEX;
    pos = pos - NODE_POSITION_WORLD;
}

void fragment() {
    ALBEDO = vec3(pos.y/100.0,pos.y/100.0,pos.y/100.0);
}