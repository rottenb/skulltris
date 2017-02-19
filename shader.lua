local list = {

	waves = {
		body = [[
			p.x += sin(p.y*waves_amount+waves_time*6)*0.03;
			finTex = Texel(tex, p);
		]], externs = {time = 0, amount = 5}},

	rgb  = {
		body = [[
			a = 0.0025 * rgb_amount;
			finTex.r = 	texture2D(tex, vec2(p.x + a * rgb_dirs[0], p.y + a * rgb_dirs[1])).r;
			finTex.g = texture2D(tex, vec2(p.x + a * rgb_dirs[2], p.y + a * rgb_dirs[3])).g;
			finTex.b = 	texture2D(tex, vec2(p.x + a * rgb_dirs[4], p.y + a * rgb_dirs[5])).b;
		]], externs = {dirs = {1,0,0,1,-1,-1}, amount = 3}},
}

local functions = {
	rand = [[float rand(vec2 co, float v) {
			return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453 * v);
		}]],
	wave = [[float wave(float x, float amount) {
	  		return (sin(x * amount) + 1.) * .5;
		}]]

}

local function getExternType(a)
	local t = type(a)
	if t == "number" then return "float" end
	if t == "boolean" then return "bool" end
	if t == "table" then
		local t2 = type(a[1])
		if t2 == "number" then
			if #a <= 4 then
				return "vec" .. #a
			else
				return "float[" .. #a .. "]"
			end
		elseif t2 == "table" then
			return "vec" .. #a[1] .. "[" .. #a .. "]"
		end
	end
end

local Shader = {}

function Shader.new(...)
	local names = {...}

	local funcs = {}
	local externs = {}
	local header = [[
		vec4 effect(vec4 color, Image tex, vec2 p, vec2 pc) {
		vec4 finTex = Texel(tex, p);
		vec2 np;
		float a, b, c;
	]]
	local bodies = {}

	for i,v in ipairs(names) do
		local shader = list[v]
		table.insert(bodies, shader.body)

		for k,ext in pairs(shader.externs) do
			table.insert(externs, "extern " .. getExternType(ext) .. " " .. v .. "_" .. k .. ";\n")
		end

		if shader.funcs then
			for i,func in ipairs(shader.funcs) do
				table.insert(funcs, functions[shader.funcs[i]])
			end
		end
	end

	extern_string = table.concat(externs, "")
	funcs_string = table.concat(lume.set(funcs), "")
	body_string = table.concat(bodies, "")
	local footer = "return finTex;}"
	local final = extern_string .. funcs_string .. header .. body_string .. footer

	local s = love.graphics.newShader(final)
	for i,v in ipairs(names) do
		for k,ext in pairs(list[v].externs) do
			if type(ext) == "table" and #ext > 4 then
				s:send(v.."_"..k, unpack(ext))
			else
				s:send(v.."_"..k, ext)
			end
		end
	end
	return s
end


--check whether a shader has a certain extern
function Shader.has(name, extern)
	return list[name].externs[extern]
end


return Shader
