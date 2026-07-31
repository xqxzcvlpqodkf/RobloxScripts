--!nocheck

local HTTP_SERVICE = game:GetService("HttpService")

local REPOSITORY_URL = "https://raw.githubusercontent.com/xqxzcvlpqodkf/RobloxScripts/main/"
local MANIFEST_URL = REPOSITORY_URL .. "manifest.json"

local PLACE_ID = tostring(game.PlaceId)

print("[DEBUG] Script initialized.")
print("[DEBUG] Target PlaceId:", PLACE_ID)

local function Fetch(url)
    print("[DEBUG] Fetching URL:", url)
    local success, result = pcall(game.HttpGet, game, url)
    
    if success then
        print("[DEBUG] [SUCCESS] Fetch succeeded for:", url)
        return result
    else
        warn("[DEBUG] [WARN] Fetch failed for:", url, "| Error:", tostring(result))
        return nil
    end
end

local function LoadManifest()
    print("[DEBUG] Attempting to load manifest...")
    local raw_json = Fetch(MANIFEST_URL)
    
    if not raw_json then 
        warn("[DEBUG] [ERROR] Failed to obtain raw manifest JSON.")
        return nil 
    end

    print("[DEBUG] Decoding manifest JSON...")
    local success, decoded = pcall(HTTP_SERVICE.JSONDecode, HTTP_SERVICE, raw_json)
    
    if success and type(decoded) == "table" then
        print("[DEBUG] [SUCCESS] Manifest decoded successfully.")
        return decoded
    else
        warn("[DEBUG] [ERROR] JSON decode failed or result was not a table. Error:", tostring(decoded))
        return nil
    end
end

local function ExecuteScript(path)
    local script_url = REPOSITORY_URL .. path
    print("[DEBUG] Executing script from path:", path)
    
    local source = Fetch(script_url)
    if not source then 
        warn("[DEBUG] [ERROR] Script source missing or failed to fetch:", script_url)
        return 
    end

    print("[DEBUG] Compiling script source...")
    local executable, err = loadstring(source)
    
    if executable then
        print("[DEBUG] [SUCCESS] Script compiled successfully. Running script...")
        local exec_success, exec_err = pcall(executable)
        if exec_success then
            print("[DEBUG] [SUCCESS] Script executed without runtime errors.")
        else
            warn("[DEBUG] [ERROR] Runtime error during script execution:", tostring(exec_err))
        end
    else
        warn("[DEBUG] [ERROR] Syntax error in script (loadstring failed):", tostring(err))
    end
end

local genv = getgenv()

genv.LOCAL_NOTIFICATION = function(title, text, duration)
    print("[DEBUG] Sending notification:", title, "|", text, "| Duration:", tostring(duration))
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
print("[DEBUG] Environment variables assigned to getgenv().")

local manifest = LoadManifest()

if manifest then
    print("[DEBUG] Manifest loaded. Checking PlaceId entry...")
    if manifest[PLACE_ID] then
        print("[DEBUG] [SUCCESS] PlaceId match found in manifest:", manifest[PLACE_ID])
        ExecuteScript(manifest[PLACE_ID])
    else
        warn("[DEBUG] [WARN] Current PlaceId (" .. PLACE_ID .. ") is not mapped in the manifest.")
    end
else
    warn("[DEBUG] [ERROR] Aborting script execution due to manifest load failure.")
end
