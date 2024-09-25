local function vtable_bind(module,interface,index,type)
	local addr = ffi.cast("void***", utils.find_interface(module, interface)) or error(interface..' is nil.')
	return ffi.cast(ffi.typeof(type), addr[0][index]),addr
end

local function __thiscall(func, this) -- bind wrapper for __thiscall functions
	return function(...)
		return func(this, ...)
	end
end


local nativeGetClipboardTextCount = __thiscall(vtable_bind("vgui2.dll", "VGUI_System010", 7, "int(__thiscall*)(void*)"))
local nativeSetClipboardText = __thiscall(vtable_bind("vgui2.dll", "VGUI_System010", 9, "void(__thiscall*)(void*, const char*, int)"))
local nativeGetClipboardText = __thiscall(vtable_bind("vgui2.dll", "VGUI_System010", 11, "int(__thiscall*)(void*, int, const char*, int)"))

local char_arr = ffi.typeof("char[?]")

local clipboard={}


clipboard.get=function()
	local text_length=nativeGetClipboardTextCount()
	if text_length > 0 then
		local clipboard_text = char_arr(text_length)
		nativeGetClipboardText(0, clipboard_text, text_length)
		return ffi.string(clipboard_text, text_length-1)
	end
	return nil
end

clipboard.set=function(text)
	text=tostring(text)
	nativeSetClipboardText(text, string.len(text))
end

clipboard.paste=clipboard.get
clipboard.copy=clipboard.set

return clipboard