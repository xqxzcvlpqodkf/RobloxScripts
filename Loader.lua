--!nocheck

local HTTP_SERVICE = game:GetService("HttpService")

local REPOSITORY_URL = "https://raw.githubusercontent.com/xqxzcvlpqodkf/RobloxScripts/main/"
local MANIFEST_URL = REPOSITORY_URL .. "manifest.json"

local PLACE_ID = tostring(game.PlaceId)

local function Fetch(url)
    local success, result = pcall(game.HttpGet, game, url)
    
    if success then
        return result
    else
        return nil
    end
end

local function LoadManifest()
    local raw_json = Fetch(MANIFEST_URL)
    
    if not raw_json then 
        return nil 
    end
    
    local success, decoded = pcall(HTTP_SERVICE.JSONDecode, HTTP_SERVICE, raw_json)
    
    if success and type(decoded) == "table" then
        return decoded
    else
        return nil
    end
end

local function ExecuteScript(path)
    local script_url = REPOSITORY_URL .. path
    
    local source = Fetch(script_url)
    if not source then 
        return 
    end
    
    local executable, err = loadstring(source)
    
    if executable then
        local exec_success, exec_err = pcall(executable)
        
        if not exec_success then
            warn("[DEBUG] [ERROR] Runtime error during script execution:", tostring(exec_err))
        end
    else
        warn("[DEBUG] [ERROR] Syntax error in script (loadstring failed):", tostring(err))
    end
end

local genv = getgenv()

genv.LOCAL_NOTIFICATION = function(title, text, duration)
    local success, err = pcall(function()
        game:GetService("StarterGui"):SetCore("SendNotification", {
            Title = title,
            Text = text,
            Duration = duration
        })
    end)
    
    if not success then
        warn("[DEBUG] [WARN] SetCore SendNotification failed:", tostring(err))
    end
end

genv.AUTH_TABLE = {""}

local manifest = LoadManifest()

if manifest then
    if manifest[PLACE_ID] then
        ExecuteScript(manifest[PLACE_ID])
    else
        warn("[DEBUG] [WARN] Current PlaceId (" .. PLACE_ID .. ") is not mapped in the manifest.")
    end
else
    warn("[DEBUG] [ERROR] Aborting script execution due to manifest load failure.")
end
