
float timeCos(float offset, float time, float scale){
	return cos(offset + time * scale);
}

float timeSin(float offset, float time, float scale){
	return sin(offset + time * scale);
}

float fireDistortDelta(float transition, float freq, float amount, float minDistort, float time, float speed){
	float final = 0.0;
	
	final = timeSin(transition * freq, time, speed);
	final *= amount;
	final = max(final, minDistort);
	final *= transition;
	
	return final;
}