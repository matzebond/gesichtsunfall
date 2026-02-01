shader_type canvas_item;

uniform vec3 outline_color: source_color;
uniform float width = 0.1;
uniform float size = 4.0;
void fragment() {
	float outline = 0.0;
	for(int x = -1; x<=1;x++){
		for(int y = -1; y<=1;y++){
			if(x==0&&y==0){
				continue;
			}
			else{
			 outline += texture(TEXTURE,UV+vec2(float(x),float(y))*TEXTURE_PIXEL_SIZE*size).a;
			}
		}
	}
	outline = min(outline,1.0);
	COLOR = mix(COLOR,vec4(0.0,0.0,0.0,1.0),outline-COLOR.a);
}