-- get newest commit ids
local function getCommit(url)
	for i,v in pairs(game:HttpGet(url):split("\n")) do 
		if v:find("commit") and v:find("fragment") then 
			local str = v:split("/")[5]
			return str:sub(0, str:find('"') - 1)
		end
	end
	return nil
end

-- Get the commit hashes or if failed set it to "main" to attempt to grab the code
local commit = (getCommit("https://github.com/7GrandDadPGN/VapeV4ForRoblox") or "main")

local RTcommit = (getCommit("https://github.com/Roblox-Thot/VapeThotMod") or "main")

if isfolder("vape") then
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
	end
else
	makefoler("vape")
end

-- Save hashes
writefile("vape/commithash.txt", commit)
writefile("vape/RTcommithash.txt", RTcommit)

loadstring(game:HttpGet("https://raw.githubusercontent.com/Roblox-Thot/VapeThotMod/"..RTcommit.."/MainScript.lua", true))()