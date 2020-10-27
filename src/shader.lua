shader = {}

shader.decal = [[
	uniform float millis;
	uniform float speed;
	vec4 effect( vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords )
	{
		vec2 uv = vec2(
			texture_coords.x + sin(texture_coords.y/2+millis)/10,
			texture_coords.y + cos(texture_coords.x/2+millis)/10 - (millis*speed/100)
		);

		vec4 texcolor = Texel(tex, uv);
		return texcolor * color;
	}
]]