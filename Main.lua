-- N3 mogg hub — Main Loader
-- Loads Library and MM2 script from GitHub

local BASE = "https://raw.githubusercontent.com/Neromxmd/N3-mogged-hub/main/"

local function fetch(name)
    local url = BASE .. name
    local ok, src = pcall(game.HttpGet, game, url)
    if not ok or type(src) ~= "string" or #src < 100 then
        error("[N3 mogg hub] Failed to load " .. name .. " from " .. url, 0)
    end
    return src
end

-- Load the UI library first, expose it globally so the MM2 script can grab it
local librarySource = fetch("Library.lua")
local libraryChunk, libraryErr = loadstring(librarySource, "Library")
if not libraryChunk then
    error("[N3 mogg hub] Library compile error: " .. tostring(libraryErr), 0)
end
local ok1, Library = pcall(libraryChunk)
if not ok1 or not Library then
    error("[N3 mogg hub] Library runtime error: " .. tostring(Library), 0)
end
_G.N3MoggLibrary = Library

-- Load the MM2 game script
local mm2Source = fetch("MM2.lua")
local mm2Chunk, mm2Err = loadstring("local Library = _G.N3MoggLibrary\n" .. mm2Source, "MM2")
if not mm2Chunk then
    error("[N3 mogg hub] MM2 compile error: " .. tostring(mm2Err), 0)
end
local ok2, mm2Result = pcall(mm2Chunk)
if not ok2 then
    error("[N3 mogg hub] MM2 runtime error: " .. tostring(mm2Result), 0)
end

print("[N3 mogg hub] Loaded successfully.")
