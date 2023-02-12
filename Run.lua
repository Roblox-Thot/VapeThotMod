-- get newest vape commit id
local commit = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/7GrandDadPGN/VapeV4ForRoblox/commits", true))[1].commit.url:split("/commits/")[2]
local RTcommit = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://api.github.com/repos/Roblox-Thot/VapeThotMod/commits", true))[1].commit.url:split("/commits/")[2]
if ((not isfile("vape/commithash.txt")) or readfile("vape/commithash.txt") ~= commit or (not isfile("vape/RTcommithash.txt")) or readfile("vape/RTcommithash.txt") ~= RTcommit) then
	for i,v in pairs({"vape/Universal.lua", "vape/MainScript.lua", "vape/GuiLibrary.lua"}) do 
		if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
			delfile(v)
		end 
	end
	if isfolder("vape/CustomModules") then 
		for i,v in pairs(listfiles("vape/CustomModules")) do 
			if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
				delfile(v)
			end 
		end
	end
	if isfolder("vape/Libraries") then 
		for i,v in pairs(listfiles("vape/Libraries")) do 
			if isfile(v) and readfile(v):find("--This watermark is used to delete the file if its cached, remove it to make the file persist after commits.") then
				delfile(v)
			end 
		end
	end
	writefile("vape/commithash.txt", commit)
	writefile("vape/RTcommithash.txt", RTcommit)
end


loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox-Thot/VapeThotMod/"..RTcommit.."/MainScript.lua", true))()