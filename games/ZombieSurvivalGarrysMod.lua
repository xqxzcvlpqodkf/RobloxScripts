--!nocheck

if not getgenv().AUTH_TABLE then
  getgenv().LOCAL_NOTIFICATION("Error", "F9 for more details", 9999)
  return warn("[Script Error]: error in loader initialization)
end

if not gethwid then
  getgenv().LOCAL_NOTIFICATION("Error", "F9 for more details", 9999)
  return warn("[Script Error]: cannot validate authentication")
end

if not table.find(getgenv().AUTH_TABLE, gethwid()) then
  getgenv().LOCAL_NOTIFICATION("Error", "F9 for more details", 9999)
  return warn("[Script Error]: not authenticated")
end

local obfuscated_src;
if obfuscated_src then obfuscated_src() end
