float getTotalValue(in vec2 vec,in vec2 vec1,float normalizedAge,out vec2 outkey)
{
	if(vec.x>=vec1.x){
		return 0.;
	}
	float time=clamp(normalizedAge,vec.x,vec1.x);
	float p=(time-vec.x)/(vec1.x-vec.x);
	float v=mix(vec.y,vec1.y,p);
	outkey.x=time;
	outkey.y=v;
	return(v+vec.y)*(time-vec.x)*.5;
}

void getFrameValue(in vec2 vec,in vec2 vec1,float normalizedAge,out vec2 outkey){
	if(normalizedAge<=vec.x||vec.x>=vec1.x){
		return;
	}else{
		outkey.x=normalizedAge;
		float p=(normalizedAge-vec.x)/(vec1.x-vec.x);
		outkey.y=mix(vec.y,vec1.y,p);
	}
}

float getCurValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)
{
	vec2 lastKey=gradientNumbers[0];
	for(int i=1;i<4;i++)
	{
		getFrameValue(gradientNumbers[i-1],gradientNumbers[i],normalizedAge,lastKey);
	}
	return lastKey.y;
}

float getTotalValueFromGradientFloat(in vec2 gradientNumbers[4],in float normalizedAge)
{
	float lastValue=gradientNumbers[0].y;
	float lasttime=gradientNumbers[0].x;
	float totalValue=min(lasttime,normalizedAge)*lastValue;
	vec2 lastKey=vec2(lasttime,lastValue);
	totalValue+=getTotalValue(gradientNumbers[0],gradientNumbers[1],normalizedAge,lastKey);
	totalValue+=getTotalValue(gradientNumbers[1],gradientNumbers[2],normalizedAge,lastKey);
	totalValue+=getTotalValue(gradientNumbers[2],gradientNumbers[3],normalizedAge,lastKey);
	
	return(totalValue+(max(normalizedAge,lastKey.x)-lastKey.x)*lastKey.y)*a_ShapePositionStartLifeTime.w;
}

vec4 getColorFromGradient(in vec2 gradientAlphas[COLORCOUNT],
	in vec4 gradientColors[COLORCOUNT],
in float normalizedAge,in vec4 keyRanges)
{
	float alphaAge=clamp(normalizedAge,keyRanges.z,keyRanges.w);
	vec4 overTimeColor;
	for(int i=1;i<COLORCOUNT;i++)
	{
		vec2 gradientAlpha=gradientAlphas[i];
		float alphaKey=gradientAlpha.x;
		if(alphaKey>=alphaAge)
		{
			vec2 lastGradientAlpha=gradientAlphas[i-1];
			float lastAlphaKey=lastGradientAlpha.x;
			float age=clamp((alphaAge-lastAlphaKey)/(alphaKey-lastAlphaKey),0.,1.);
			overTimeColor.a=mix(lastGradientAlpha.y,gradientAlpha.y,age);
			break;
		}
	}
	
	float colorAge=clamp(normalizedAge,keyRanges.x,keyRanges.y);
	for(int i=1;i<COLORCOUNT;i++)
	{
		vec4 gradientColor=gradientColors[i];
		float colorKey=gradientColor.x;
		if(colorKey>=colorAge)
		{
			vec4 lastGradientColor=gradientColors[i-1];
			float lastColorKey=lastGradientColor.x;
			float age=(colorAge-lastColorKey)/(colorKey-lastColorKey);
			overTimeColor.rgb=mix(gradientColors[i-1].yzw,gradientColor.yzw,age);
			break;
		}
	}
	return overTimeColor;
}

float getFrameFromGradient(in vec2 gradientFrames[4],in float normalizedAge)
{
	vec2 lastKey=vec2(0.,gradientFrames[0].y);
	for(int i=1;i<4;i++)
	{
		getFrameValue(gradientFrames[i-1],gradientFrames[i],normalizedAge,lastKey);
	}
	return floor(lastKey.y);
}
