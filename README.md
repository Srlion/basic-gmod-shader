# Simple Garry's Mod Shader

This is just a barebone example of how to use shaders in Garry's Mod.

## How to use

1. Git clone this repository.
2. Open src/main.lua and change the `ADDON_NAME` variable to your addon name.
3. Open the file `compile_shader_list.txt` and add your shaders to the list.
4. Run `build.py` to compile the shaders. (`python build.py`)
5. Copy `compiled/main.lua` to whatever place you want and run `include` on it. (It already calls `AddCSLuaFile` for you.)
6. Voila!

## Writing a shader from scratch

1. Create a new file in `src/` eg. `src/boom_psxx.hlsl`.
2. Add the following code to it:

```c
#include "common.hlsl"

float4 main(PS_INPUT i) : COLOR {
    return i.color;
}
```

3. Add the file to `compile_shader_list.txt`.
   - You can compile the shader to multiple versions by adding `-v-30` or `-v-20b` or both at the same time.
   - If you don't specify a version, it will default to `-v-20b`.
   - If you are going to use version 30, you need to also use a vertex shader with it to work correctly.

it should look like this:

```
boom_psxx.hlsl -v-30
```

or

```
boom_psxx.hlsl -v-30 -v-20b
```

4. Inside `src/main.lua`, add the following code:

```lua
local SHADER_MAT = create_shader_mat("boom", {
	-- pixshader/vertexshader must end with _ps30/_vs30/_ps20b
	["$pixshader"] = GET_SHADER("boom_ps30"),
	["$vertexshader"] = GET_SHADER("my_shader_vertex_vs30"),
})
```

5. Now run `build.py` to compile the shaders.

## FAQ

### How can I check which version we are compiling for inside the shader?

```c
#ifdef SHADER_MODEL_PS_3_0
    // shader is compiled for ps 3.0
#else
    // shader is compiled for ps 2.0
#endif
```
