local ADDON_NAME = "addon_name_here"

if SERVER then
	AddCSLuaFile()
	return
end

----------------------- DO NOT TOUCH -----------------------
local SHADERS_VERSION = "SHADERS_VERSION_PLACEHOLDER"
local SHADERS_GMA = [========[SHADERS_GMA_PLACEHOLDER]========]
do
	local DECODED_SHADERS_GMA = util.Base64Decode(SHADERS_GMA)
	if not DECODED_SHADERS_GMA or #DECODED_SHADERS_GMA == 0 then
		print("Failed to load shaders!") -- this shouldn't happen
		return
	end
	local gma_name = ADDON_NAME .. "_shaders_" .. SHADERS_VERSION .. ".gma"
	file.Write(gma_name, DECODED_SHADERS_GMA)
	game.MountGMA("data/" .. gma_name)
end

local function GET_SHADER(name)
	return SHADERS_VERSION .. "_" .. name
end
----------------------- DO NOT TOUCH -----------------------

local shader_mat = [==[
screenspace_general
{
	$pixshader ""
	$vertexshader ""

	$basetexture ""
	$texture1    ""
	$texture2    ""
	$texture3    ""

	// Mandatory, don't touch
	$ignorez            1
	$vertexcolor        1
	$vertextransform    1
	"<dx90"
	{
		$no_draw 1
	}

	$copyalpha                 0
	$alpha_blend_color_overlay 0
	$alpha_blend               1 // whether or not to enable alpha blend
	$linearwrite               1 // to disable broken gamma correction for colors
	$linearread_basetexture    1 // to disable broken gamma correction for textures
}
]==]


local function create_shader_mat(name, opts)
	assert(name and isstring(name), "create_shader_mat: tex must be a string")
	local key_values = util.KeyValuesToTable(shader_mat, false, true)
	if opts then
		for k, v in pairs(opts) do
			key_values[k] = v
		end
	end
	return CreateMaterial(
		ADDON_NAME .. name .. SysTime(),
		"screenspace_general",
		key_values
	)
end

local SHADER_MAT = create_shader_mat("my_first_shader", {
	-- pixshader/vertexshader must end with _ps30/_vs30/_ps20b
	["$pixshader"] = GET_SHADER("my_shader_ps30"),
	["$vertexshader"] = GET_SHADER("my_shader_vertex_vs30"),
})

-- if using shader model 2.0, then make it this:
--[[
	local SHADER_MAT = create_shader_mat("rounded", {
		["$pixshader"] = GET_SHADER("my_shader_ps20b"),
		-- ps20b don't have vertex shader
	})
]]

-- These are the parameters that you can use to pass them to your shader
local P1, P2, P3, P4 = "$c0_x", "$c0_y", "$c0_z", "$c0_w"
local P5, P6, P7, P8 = "$c1_x", "$c1_y", "$c1_z", "$c1_w"
local P9, P10, P11, P12 = "$c2_x", "$c2_y", "$c2_z", "$c2_w"
local P13, P14, P15, P16 = "$c3_x", "$c3_y", "$c3_z", "$c3_w"

local function draw_my_shader(x, y, w, h, p1, p2, p3, p4)
	SHADER_MAT:SetFloat(P1, p1)
	SHADER_MAT:SetFloat(P2, p2)
	SHADER_MAT:SetFloat(P3, p3)
	SHADER_MAT:SetFloat(P4, p4)

	surface.SetDrawColor(255, 255, 255, 255)
	surface.SetMaterial(SHADER_MAT)
	-- https://github.com/Jaffies/rboxes/blob/main/rboxes.lua
	-- fixes setting $basetexture to ""(none) not working correctly
	surface.DrawTexturedRectUV(x, y, w, h, -0.015625, -0.015625, 1.015625, 1.015625)
end

hook.Add("HUDPaint", "my_shader_draw", function()
	draw_my_shader(100, 100, 200, 200, 0, 0, 0, 1)
end)
