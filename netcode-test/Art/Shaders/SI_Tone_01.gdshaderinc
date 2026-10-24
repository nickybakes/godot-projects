vec3 rotateAroundAxis(vec3 vector, vec3 axis, float angle) {
// RotationByAxis:6
	axis = normalize(axis);
	mat3 rot_matrix = mat3(
		vec3( cos(angle)+axis.x*axis.x*(1.0 - cos(angle)), axis.x*axis.y*(1.0-cos(angle))-axis.z*sin(angle), axis.x*axis.z*(1.0-cos(angle))+axis.y*sin(angle) ),
		vec3( axis.y*axis.x*(1.0-cos(angle))+axis.z*sin(angle), cos(angle)+axis.y*axis.y*(1.0-cos(angle)), axis.y*axis.z*(1.0-cos(angle))-axis.x*sin(angle) ),
		vec3( axis.z*axis.x*(1.0-cos(angle))-axis.y*sin(angle), axis.z*axis.y*(1.0-cos(angle))+axis.x*sin(angle), cos(angle)+axis.z*axis.z*(1.0-cos(angle)) )
	);

	return vector * rot_matrix;
}

vec2 tone(vec3 vertex){
	vec2 camCoord = (rotateAroundAxis(vertex, vec3(0, 0, 1), .785).xy + vec2(.5, .5)) * vec2(40, 40);
	float sine = abs(sin(camCoord.x));
	float cosine = abs(cos(camCoord.y));
	return vec2(sine, cosine * sine);
}
