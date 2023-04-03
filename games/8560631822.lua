local function betterisfile(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

local function getScript(scripturl)
	local suc, res = pcall(function() return game:HttpGet"https://raw.githubusercontent.com/Roblox-Thot/VapeThotMod/"..readfile("vape/RTcommithash.txt").."/games/6872274481.lua", true) end)
	if not suc or res == "404: Not Found" then return nil end
	return res
end

shared.CustomSaveVape = 6872274481
if betterisfile("vape/CustomModules/6872274481.lua") then
	loadstring(readfile("vape/CustomModules/6872274481.lua"))()
else
	local publicrepo = vapeGithubRequest("games/6872274481.lua")
	if publicrepo then
		loadstring(publicrepo)()
	end
end