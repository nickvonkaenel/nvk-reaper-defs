local r = reaper
local script_path = debug.getinfo(1, "S").source:match("@(.*)[\\/].*$")

--------------------------------------------------------------------------------
-- Helper: Remove HTML tags and convert <br> to newlines.
local function strip_html(s)
	s = s:gsub("<br>", "\n")
	s = s:gsub("<.->", "")
	-- Decode common HTML entities:
	s = s:gsub("&amp;", "&")
	s = s:gsub("&lt;", "<")
	s = s:gsub("&gt;", ">")
	s = s:gsub("&quot;", '"')
	s = s:gsub("&#39;", "'")
	return s:gsub("^%s*(.-)%s*$", "%1")
end

--------------------------------------------------------------------------------
-- Parse the Lua function signature.
-- Returns a table with:
--   func_name (e.g. "reaper.Xen_AudioWriter_Create")
--   ret_type (or nil if none)
--   params (a list of { name, type, optional })
local function parse_lua_signature(sig)
	local ret_types = {}
	local func_name, params_str

	if sig:find("=") then
		-- Handle multiple return values.
		local ret_part, rest = sig:match("^(.-)%s*=%s*(.*)$")
		if not ret_part or not rest then
			error("Could not split return part and function signature in: " .. sig)
		end
		-- Parse each return value from the left side.
		for part in ret_part:gmatch("[^,]+") do
			part = part:match("^%s*(.-)%s*$")
			if #part > 0 then
				local type_str, name = part:match("^<i>(.-)</i>%s*(%S+)$")
				local optional_ret = false
				if type_str and type_str:match("^optional%s+") then
					optional_ret = true
					type_str = type_str:gsub("^optional%s+", "")
				end
				if not type_str then
					-- Try matching just the type without a name.
					type_str = part:match("^<i>(.-)</i>%s*$")
					if type_str then
						name = "retval"
					else
						error("Could not parse return type part: " .. part)
					end
				end
				-- Remove stray italic tags.
				type_str = type_str:gsub("</?i>", "")
				if name then
					name = name:gsub("</?i>", "")
				end
				table.insert(ret_types, { type = type_str, name = name, optional = optional_ret })
			end
		end
		func_name, params_str = rest:match("^(reaper%.[%w_]+)%s*%((.-)%)")
		if not func_name then
			error("Could not parse function name from: " .. rest)
		end
	else
		-- No '=' present; check for an inline return type.
		local ret_type = sig:match("^<i>(.-)</i>%s+")
		if ret_type then
			func_name, params_str = sig:match("^<i>.-</i>%s+(reaper%.[%w_]+)%s*%((.-)%)")
			if not func_name then
				error("Could not parse function name from: " .. sig)
			end
			ret_types = { { type = ret_type, name = "retval" } }
		else
			func_name, params_str = sig:match("^(reaper%.[%w_]+)%s*%((.-)%)")
			if not func_name then
				error("Could not parse function name from: " .. sig)
			end
			ret_types = {}
		end
	end

	local params = {}
	for param in params_str:gmatch("[^,]+") do
		param = param:match("^%s*(.-)%s*$")
		if #param > 0 then
			-- Try matching an italic tag first…
			local type_str, name = param:match("^<i>(.-)</i>%s*(%S+)$")
			if not type_str then
				-- …and if that fails, try matching a bold tag.
				type_str, name = param:match("^<b>(.-)</b>%s*(%S+)$")
			end
			if not type_str then
				name = param
				type_str = "any"
			end
			-- Remove any stray italic or bold tags from type and name.
			type_str = type_str:gsub("</?i>", ""):gsub("</?b>", "")
			if name then
				name = name:gsub("</?i>", ""):gsub("</?b>", "")
				-- Also replace dots in parameter names (e.g. r.left => r_left)
				name = name:gsub("%.", "_")
			end
			local optional = false
			if type_str:match("^optional%s+") then
				optional = true
				type_str = type_str:gsub("^optional%s+", "")
			end
			if type_str == "identifier" then
				type_str = "userdata"
			end
			table.insert(params, { name = name, type = type_str, optional = optional })
		end
	end

	return {
		func_name = func_name,
		ret_types = ret_types,
		params = params,
	}
end

--------------------------------------------------------------------------------
-- Parse one function block.
-- Expects block text containing several <div> elements and a trailing description.
local function parse_block(block)
	-- Extract the Lua signature from the <div class="l_func"> block.
	local lua_sig = block:match('<div class="l_func">.-<code>(.-)</code>')
	if not lua_sig then
		return nil -- skip if no Lua definition found
	end

	local parsed = parse_lua_signature(lua_sig)

	-- Remove all <div ...>...</div> blocks to avoid extra signatures in the description.
	local description_raw = block:gsub('<div class=".-">.-</div>', "")
	-- Now strip remaining HTML (like <br> tags)
	parsed.description = strip_html(description_raw)
	return parsed
end

--------------------------------------------------------------------------------
-- Parse all function blocks in the HTML defs.
local function parse_all(html)
	local funcs = {}
	-- Remove all hyperlink tags with href so they don't interfere.
	html = html:gsub('<a%s+href=".-">(.-)</a>', "%1")

	local pos = 1
	while true do
		-- Find the next block anchor.
		local start_pos, end_pos, anchor = html:find('<a name="(.-)"><hr></a>', pos)
		if not start_pos then
			break
		end

		-- Find the start of the next anchor.
		local next_anchor_pos = html:find('<a name="', end_pos + 1)
		local block
		if next_anchor_pos then
			block = html:sub(end_pos + 1, next_anchor_pos - 1)
		else
			block = html:sub(end_pos + 1)
		end

		-- Skip if the anchor is "END" or if parse_block returns nil.
		if anchor ~= "END" then
			local func = parse_block(block)
			if func then
				if
					(func.func_name:match("^reaper%.ImGui") or func.func_name:match("^reaper%.AK"))
					and func.func_name ~= "reaper.ImGui_GetBuiltinPath"
				then
				-- Skip this definition.
				else
					table.insert(funcs, func)
				end
			end
		end

		pos = next_anchor_pos or (#html + 1)
	end

	return funcs
end

--[[

---@param gGUID string 
---@return string gGUID
function reaper.genGuid(gGUID) end

should be

---@return string retval
function reaper.genGuid() end
-------------------------
seems like most functions which return a string have the variable changed to retval
buf
hashNeed128
filenamebuf
typebuf
action
author
notes
GUID
destNeed64
out
strNeed64
gGUID
fn
guidString
double
class
---------------
GetSet_ArrangeView2: start_time and end_time are optional
GetThemeColor: flags is optional
LocalizeString: flags is optional
Main_SaveProjectEx: forceSaveAsIn is optional
SetCursorContext: envIn is optional
ShowPopupMenu: everything except name and y optional? seems odd that x would be optional
JS_Composite_Unlink: bitmap is optional
JS_Window_Create: ownerHWND is optional
JS_Window_SetParent: parentHWND is optional
JS_Window_SetZOrder: insertAfterHWND is optional
JS_Zip_Close: zipHandle is optional
---------------
GetItemEditingTime2 is missing first return value in sexan defs
---------------
functions missing in sexan defs:
GetSetTempoTimeSigMarkerFlag
GetSetTrackGroupMembershipEx
---------------
less thans (<) are flipped in sexan defs
---------------
my_getViewport is missing return values in reaper documentation
---------------
SetThemeColor includes a ton of current RGB colors that probably aren't necessary
---------------
BR_GetMouseCursorContext has a completely jank chart in the description
---------------
unsupported is replaced with optional boolean
]]

local param_type_substitutions = {
	{ "ReaProject", "ReaProject|nil|0" },
	{ "KbdSectionInfo", "KbdSectionInfo|integer" },
	{ "desttrIn", "desttrIn?" },
	{ "%s+$", "" }, -- remove trailing space
}

local optional_params = {
	GetSet_ArrangeView2 = {
		start_time = true,
		end_time = true,
	},
	GetThemeColor = {
		flags = true,
	},
	LocalizeString = {
		flags = true,
	},
	Main_SaveProjectEx = {
		forceSaveAsIn = true,
	},
	SetCursorContext = {
		envIn = true,
	},
	ShowPopupMenu = {
		x = true,
		y = true,
		hwndParent = true,
		ctx = true,
		ctx2 = true,
		ctx3 = true,
	},
	JS_Composite_Unlink = {
		bitmap = true,
	},
	JS_Window_Create = {
		ownerHWND = true,
	},
	JS_Window_SetParent = {
		parentHWND = true,
	},
	JS_Window_SetZOrder = {
		insertAfterHWND = true,
	},
	JS_Zip_Close = {
		zipHandle = true,
	},
	CreateTrackSend = {
		desttrIn = true,
	},
}

local manual_overrides = {
	genGuid = [[---Generates a new GUID string e.g. {35C37676-7CFF-7E46-BB14-FA0CC7C04BEB}
---@return string gGUID
function reaper.genGuid() end]],
	my_getViewport = [[---@param r_left integer
---@param r_top integer
---@param r_right integer
---@param r_bot integer
---@param sr_left integer
---@param sr_top integer
---@param sr_right integer
---@param sr_bot integer
---@param wantWorkArea boolean
---@return integer left
---@return integer top
---@return integer right
---@return integer bottom
function reaper.my_getViewport(r_left, r_top, r_right, r_bot, sr_left, sr_top, sr_right, sr_bot, wantWorkArea) end]],
	["reaper.BR_GetMouseCursorContext"] = [[---[BR] Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.
---
---+------------+----------------+------------------------------------------------+
---| Window     | Segment        | Details                                        |
---+------------+----------------+------------------------------------------------+
---| unknown    | ""             | ""                                             |
---+------------+----------------+------------------------------------------------+
---| ruler      | region_lane    | ""                                             |
---|            | marker_lane    | ""                                             |
---|            | tempo_lane     | ""                                             |
---|            | timeline       | ""                                             |
---+------------+----------------+------------------------------------------------+
---| transport  | ""             | ""                                             |
---+------------+----------------+------------------------------------------------+
---| tcp        | track          | ""                                             |
---|            | envelope       | ""                                             |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| mcp        | track          | ""                                             |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| arrange    | track          | empty, item, item_stretch_marker,              |
---|            |                | env_point, env_segment                         |
---|            | envelope       | empty, env_point, env_segment                  |
---|            | empty          | ""                                             |
---+------------+----------------+------------------------------------------------+
---| midi_editor| unknown        | ""                                             |
---|            | ruler          | ""                                             |
---|            | piano          | ""                                             |
---|            | notes          | ""                                             |
---|            | cc_lane        | cc_selector, cc_lane                           |
---+------------+----------------+------------------------------------------------+
---To get more info on stuff that was found under mouse cursor see BR_GetMouseCursorContext_Envelope, BR_GetMouseCursorContext_Item, BR_GetMouseCursorContext_MIDI, BR_GetMouseCursorContext_Position, BR_GetMouseCursorContext_Take, BR_GetMouseCursorContext_Track 
---@return string window
---@return string segment
---@return string details
function reaper.BR_GetMouseCursorContext() end]],
}

local snippets = {}
local snippets_overrides = {
	genGuid = {
		prefix = "r.genGuid",
		scope = "lua",
		body = "r.genGuid()$0",
		description = "Generates a new GUID string e.g. {35C37676-7CFF-7E46-BB14-FA0CC7C04BEB}",
	},
	my_getViewport = {
		prefix = "r.my_getViewport",
		scope = "lua",
		body = "reaper.my_getViewport(${1:r_left}, ${2:r_top}, ${3:r_right}, ${4:r_bot}, ${5:sr_left}, ${6:sr_top}, ${7:sr_right}, ${8:sr_bot}, ${9:wantWorkArea})$0",
		description = "Get the current viewport and the work area",
	},
	BR_GetMouseCursorContext = {
		prefix = "r.BR_GetMouseCursorContext",
		scope = "lua",
		body = "r.BR_GetMouseCursorContext()$0",
		description = "Get mouse cursor context. Each parameter returns information in a form of string as specified in the table below.",
	},
}
--[[
{ [short_name] = { 
	prefix = "r." .. short_name,
	scope = "lua",
	body = "r." .. short_name .. "${1:param}, ${2:param})$0",
	description = description,
	},
}
]]

local alias_strings = {
	"Info_Value",
	"ItemInfo",
	"Info_String",
	"ProjectInfo",
}

local alias_field_names = {
	parmname = true,
	desc = true,
	parameterName = true,
}

local additional_p_ext_vals
--------------------------------------------------------------------------------
-- Generate the annotated Lua stub for a given parsed function.
local function generate_stub(func)
	local short_name = func.func_name:gsub("^reaper%.", "", 1)
	local snippet_name = "r." .. short_name
	if snippets_overrides[short_name] then
		snippets[short_name] = snippets_overrides[short_name]
	end
	if manual_overrides[short_name] then
		return manual_overrides[short_name]
	end
	local snippet = {
		prefix = snippet_name,
		scope = "lua",
	}
	local lines = {}
	local description = {}
	local alias
	if func.description and #func.description > 0 then
		local create_alias = false
		for _, alias_string in ipairs(alias_strings) do
			if short_name:find(alias_string) then
				create_alias = true
				break
			end
		end
		if create_alias then
			alias = short_name .. "_Param"
			table.insert(lines, "---@alias " .. alias)
			for line in func.description:gmatch("[^\n]+") do
				if short_name:find("RegionOrMarker") then
					for parmname in line:gmatch('"(%S-)"') do
						table.insert(lines, string.format("---| \"'%s'\"", parmname))
					end
				else
					local parmname, desc = line:match("^(%S-)%s*: (.*)$")
					if parmname and desc then
						table.insert(lines, string.format("---| \"'%s'\" %s", parmname, desc))
					end
				end
			end
			-- add user defined p_ext values
			if additional_p_ext_vals and additional_p_ext_vals[short_name] then
				for _, val in ipairs(additional_p_ext_vals[short_name]) do
					table.insert(lines, string.format("---| \"'P_EXT:%s'\"", val))
				end
			end
			table.insert(lines, "")
		end
		for line in func.description:gmatch("[^\n]+") do
			-- remove SetThemeColor additional info
			if not line:find("^-- current RGB") and not line:find("^-- blendmode") then
				table.insert(lines, "---" .. line)
				table.insert(description, line)
			end
		end
	end

	snippet.description = table.concat(description, "\n")
	snippet.body = snippet_name .. "("
	local body_params = {}
	for i, p in ipairs(func.params) do
		if alias_field_names[p.name] and alias then
			p.type = alias
		end
		local optional = optional_params[short_name] and optional_params[short_name][p.name] or p.optional
		local p_type = p.type
		for _, sub in ipairs(param_type_substitutions) do
			p_type = p_type:gsub(sub[1], sub[2], 1)
		end
		table.insert(lines, string.format("---@param %s %s", p.name, p_type .. (optional and "?" or "")))
		if p.type == "ReaProject" then
			table.insert(body_params, "0")
		else
			table.insert(body_params, string.format("${%s:%s}", i, p.name))
		end
	end
	snippet.body = snippet.body .. table.concat(body_params, ", ") .. ")$0"
	local retvals = {}
	for i, ret in ipairs(func.ret_types or {}) do
		local trimmed_type = ret.type:gsub("%s+$", "")
		local rettype = trimmed_type .. (ret.optional and "?" or "")
		rettype = rettype:gsub("identifier", "userdata", 1)
		local retname = ret.name
		if retname == "retval" then
			if ret.type == "string" then
				retname = "str"
			elseif ret.type == "number" then
				retname = "num"
			else
				retname = "rv"
			end
		end
		table.insert(lines, string.format("---@return %s %s", rettype, retname))
		table.insert(retvals, retname)
	end
	if #retvals > 1 and func.func_name:find("Get") then
		snippet.body = table.concat(retvals, ", ") .. " = " .. snippet.body
	end
	local param_names = {}
	for _, p in ipairs(func.params) do
		table.insert(param_names, p.name)
	end
	table.insert(lines, string.format("function %s(%s) end", func.func_name, table.concat(param_names, ", ")))
	snippets[short_name] = snippet
	return table.concat(lines, "\n")
end

local function snippets_to_json(snippets_header)
	local str = "{\n"
	str = str .. snippets_header
	local keys = {}
	for k in pairs(snippets) do
		table.insert(keys, k)
	end
	table.sort(keys)
	local key_tbl = {}
	for _, k in ipairs(keys) do
		local snippet = snippets[k]
		table.insert(
			key_tbl,
			string.format(
				'\t"%s lua": {\n\t\t"prefix": "%s",\n\t\t"scope": "lua",\n\t\t"body": "%s",\n\t\t"description": "%s"\n\t}',
				k,
				snippet.prefix,
				snippet.body,
				snippet.description
					:gsub("\\'", "'")
					:gsub("\\", "\\\\")
					:gsub("\n", "\\n")
					:gsub('"', "'")
					:gsub("\t", "\\t")
					:gsub("\r", "\\r")
					:gsub("\\n\\n", "\\n")
			)
		)
	end
	str = str .. table.concat(key_tbl, ",\n")
	str = str .. "\n}"
	return str
end

local function defs_to_snippets(defs)
	local field_section, functions = defs:match("(.-)\nlocal ImGui.-keyword\n(.+)")

	for desc, field, field_type in field_section:gmatch("(.-)@field%s+(.-)%s(.-)\n") do
		local desc_tbl = {
			"@type " .. field_type .. "\n---",
		}
		for line in desc:gmatch("([^\n]+)") do
			if line == "---" or line == "--- ---" then
				-- ignore
			else
				line = line:gsub("\\", "") -- remove unnecessary escapes
				table.insert(desc_tbl, line:match("^%s*%-%-%-%s*(.+)%s*$"))
			end
		end
		snippets[field] = {
			prefix = "ImGui." .. field,
			scope = "lua",
			body = "ImGui." .. field .. "$0",
			description = table.concat(desc_tbl, "\n"),
		}
	end

	for desc, func, args in functions:gmatch("(.-)\nfunction%s+(.-)%((.-)%)%s*end\n") do
		local args_tbl = {}
		local i = 1
		for arg in args:gmatch("[^,]+") do
			arg = arg:gsub("%s", "")
			if arg == "ctx" then
				table.insert(args_tbl, "ctx")
			else
				table.insert(args_tbl, string.format("${%s:%s}", i, arg))
			end
			if func == "ImGui.SameLine" then -- special case since we don't really use the other args
				break
			end
			i = i + 1
		end
		local desc_tbl = {}
		local fields_found = false
		for line in desc:gmatch("([^\n]+)") do
			if line:find("^--- @") then
				fields_found = true
			elseif fields_found then
				desc_tbl = {} -- reset since fields should only be at the end
			elseif line == "---" or line == "--- ---" then
				-- ignore
			else
				line = line:gsub("\\", "") -- remove unnecessary escapes
				table.insert(desc_tbl, line:match("^%s*%-%-%-%s*(.+)%s*$"))
			end
		end
		snippets[func:gsub("%.", "_")] = {
			prefix = func,
			scope = "lua",
			body = func .. "(" .. table.concat(args_tbl, ", ") .. ")$0",
			description = table.concat(desc_tbl, "\n"),
		}
	end
end

local file_path = r.GetExtState("ReaScript_API_Generator", "html_file_path")

if file_path == "" or not r.file_exists(file_path) then
	r.Main_OnCommand(41065, 0) -- ReaScript: Open ReaScript documentation (html)...
	local retval, new_path = r.GetUserInputs("HTML File Path", 1, "Enter path to HTML file:,extrawidth=100", "")
	if not retval then
		return
	end
	file_path = new_path:gsub("^file:/+", "")
	r.SetExtState("ReaScript_API_Generator", "html_file_path", file_path, false)
end

local function read_file(path)
	local file = io.open(path, "r")
	if file then
		local content = file:read("*all")
		file:close()
		return content
	else
		r.ShowMessageBox("Could not open file: " .. path, "Error", 0)
	end
end

local html_defs = read_file(file_path)
--------------------------------------------------------------------------------

local function get_nvim_config_path()
	local home = os.getenv("HOME")
	local appdata = os.getenv("LOCALAPPDATA")
	local path_separator = package.config:sub(1, 1) -- Gets the OS path separator (\ for Windows, / for Unix)

	if home and path_separator == "/" then
		-- Unix-like systems (macOS, Linux)
		return home .. "/.config/nvim/", path_separator
	elseif appdata then
		-- Windows
		return appdata .. "\\nvim\\", path_separator
	end
end

local nvim_path, sep = get_nvim_config_path()

local nvim_snippets_path = nvim_path .. "snippets" .. sep .. "lua" .. sep .. "reascript-api.json"
local p_ext_path = nvim_path .. "reaper" .. sep .. "p_ext_vals.lua"

if r.file_exists(p_ext_path) then
	additional_p_ext_vals = loadfile(p_ext_path)()
end

-- Main: Parse the input HTML and generate stubs.
local funcs = parse_all(html_defs)
local output = { read_file(script_path .. "/header.lua") }
for _, func in ipairs(funcs) do
	table.insert(output, generate_stub(func))
	table.insert(output, "") -- add a blank line between functions
end
table.insert(output, read_file(script_path .. "/footer.lua"))
defs_to_snippets(read_file(script_path .. "/imgui_defs.lua"))

local snippets_str = snippets_to_json(read_file(script_path .. "/snippets_header.json"))

local function write_file(path, content)
	local file = io.open(path, "w")
	if file then
		file:write(content)
		file:close()
		r.ShowConsoleMsg("\nFile written to: " .. path)
	else
		r.ShowMessageBox("\nCould not write to file: " .. path, "Error", 0)
	end
	return file
end

write_file(script_path .. "/reaper_defs.lua", table.concat(output, "\n"))
write_file(script_path .. "/snippets.json", snippets_str)
if r.file_exists(nvim_snippets_path) then
	write_file(nvim_snippets_path, snippets_str)
end
