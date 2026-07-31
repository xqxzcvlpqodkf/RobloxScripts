--!nocheck

local HTTP_SERVICE = game:GetService("HttpService")

local REPOSITORY_URL = "https://raw.githubusercontent.com/xqxzcvlpqodkf/RobloxScripts/main/"
local MANIFEST_URL = REPOSITORY_URL .. "manifest.json"

local PLACE_ID = tostring(game.PlaceId)

local function Fetch(url)
    local success, result = pcall(game.HttpGet, game, url)

    return success and result or nil
end

local function LoadManifest()
    local raw_json = Fetch(MANIFEST_URL)
    if not raw_json then return nil end

    local success, decoded = pcall(HTTP_SERVICE.JSONDecode, HTTP_SERVICE, raw_json)

    return (success and type(decoded) == "table") and decoded or nil
end

local function ExecuteScript(path)
    local source = Fetch(REPOSITORY_URL .. path)
    if not source then return end

    local executable, compilation_error = loadstring(source)

    if executable then
        executable()
    end
end

local manifest = LoadManifest()

if manifest and manifest[PLACE_ID] then
    ExecuteScript(manifest[PLACE_ID])
end
