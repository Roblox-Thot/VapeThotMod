local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local connections = {}
local repstorage = game:GetService("ReplicatedStorage")

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local checkpublicreponum = 0
local checkpublicrepo
checkpublicrepo = function()
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/"..readfile("vape/commithash.txt").."/CustomModules/6872274481.lua",
		Method = "GET"
	}) end)
	if not suc then
		checkpublicreponum = checkpublicreponum + 1
		task.spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Loading CustomModule Failed!, Attempts : "..checkpublicreponum
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			task.wait(2)
			textlabel:Destroy()
		end)
		task.wait(2)
		return checkpublicrepo()
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end
local publicrepo = checkpublicrepo()
if publicrepo then
	local regex, repin, clean = "","",publicrepo

	-- Change the top ui message
	regex = 'Moderators can ban you at any time, Always use alts%.'
	repin = "Thanks for using Thot Mod. You are sexy!"
	clean = string.gsub(tostring(clean), regex,repin)
	
    loadstring(clean)()
end

local KnitClient = debug.getupvalue(require(lplr.PlayerScripts.TS.knit).setup, 6)
local client = require(repstorage.TS.remotes).default.Client
local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
local BedwarsAppIds = require(game:GetService("StarterPlayer").StarterPlayerScripts.TS.ui.types["app-config"])["BedwarsAppIds"]
local BedwarsKillEffects = require(repstorage.TS.locker["kill-effect"]["kill-effect-meta"])["KillEffectMeta"]

local function getremote(tab)
	for i,v in pairs(tab) do
		if v == "Client" then
			return tab[i + 1]
		end
	end
	return ""
end

local function Send(Key)
	if keyclick then
		keyclick(Enum.KeyCode[Key])
	else
		-- Kept incase your shitty exploit can't keyclick
		local VM = game:GetService('VirtualInputManager')
		VM:SendKeyEvent(true,Enum.KeyCode[Key],false,game)
		VM:SendKeyEvent(false,Enum.KeyCode[Key],false,game)
	end
end

GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	for i3,v3 in pairs(connections) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) end
		if v3.disconnect then pcall(function() v3:disconnect() end) end
	end
end)

local function runcode(func)
	func()
end

local function COB(tab, argstable) 
    return GuiLibrary["ObjectsThatCanBeSaved"][tab.."Window"]["Api"].CreateOptionsButton(argstable)
end

local function createwarning(title, text, delay)
	local suc, res = pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.Frame.ImageColor3 = Color3.fromRGB(234, 255, 9)
		return frame
	end)
	return (suc and res)
end

local betterisfile = function(file)
	local suc, res = pcall(function() return readfile(file) end)
	return suc and res ~= nil
end

-- Removes panicking
GuiLibrary["RemoveObject"]("PanicOptionsButton")
GuiLibrary["RemoveObject"]("CapeOptionsButton")

runcode(function()
	local function capeFunction(char, texture, vol) -- function stolen from Vape just edited to allow .mp4
		for i,v in pairs(char:GetDescendants()) do
			if v.Name == "Cape" then
				v:Destroy()
			end
		end
		local hum = char:WaitForChild("Humanoid")
		local torso = nil
		if hum.RigType == Enum.HumanoidRigType.R15 then
			torso = char:WaitForChild("UpperTorso")
		else
			torso = char:WaitForChild("Torso")
		end
		local p = Instance.new("Part", torso.Parent)
		p.Name = "Cape"
		p.Anchored = false
		p.CanCollide = false
		p.TopSurface = 0
		p.BottomSurface = 0
		p.FormFactor = "Custom"
		p.Size = Vector3.new(0.2,0.2,0.08)
		p.Transparency = 1
		local decal
		local video = false
		if texture:find(".webm") or texture:find(".mp4") then 
			video = true
			local decal2 = Instance.new("SurfaceGui", p)
			decal2.Adornee = p
			decal2.CanvasSize = Vector2.new(1, 1)
			decal2.Face = "Back"
			decal = Instance.new("VideoFrame", decal2)
			decal.Size = UDim2.new(0, 9, 0, 17)
			decal.BackgroundTransparency = 1
			decal.Position = UDim2.new(0, -4, 0, -8)
			decal.Video = texture
			decal.Looped = true
			decal.Volume = vol/100
			decal:Play()
			-- Hide in FirstPerson
			task.spawn(function()
				local data
				repeat task.wait(1/44)
					-- data = (workspace.Camera.CFrame.Position - workspace.Camera.Focus.Position).Magnitude
					data = KnitClient.Controllers.CameraPerspectiveController:getCameraPerspective()
					-- if data-0.51 <= 0 then 
					if data == 0 then 
						decal.Visible = false
					else 
						decal.Visible = true
					end
				until not p or p.Parent ~= torso.Parent
			end)
		else
			decal = Instance.new("Decal", p)
			decal.Texture = texture
			decal.Face = "Back"
		end
		local msh = Instance.new("BlockMesh", p)
		msh.Scale = Vector3.new(9, 17.5, 0.5)
		local motor = Instance.new("Motor", p)
		motor.Part0 = p
		motor.Part1 = torso
		motor.MaxVelocity = 0.01
		motor.C0 = CFrame.new(0, 2, 0) * CFrame.Angles(0, math.rad(90), 0)
		motor.C1 = CFrame.new(0, 1, 0.45) * CFrame.Angles(0, math.rad(90), 0)
		local wave = false
		repeat task.wait(1/44)
			if video then 
				decal.Visible = torso.LocalTransparencyModifier ~= 1
			else
				decal.Transparency = torso.Transparency
			end
			local ang = 0.1
			local oldmag = torso.Velocity.magnitude
			local mv = 0.002
			if wave then
				ang = ang + ((torso.Velocity.magnitude/10) * 0.05) + 0.05
				wave = false
			else
				wave = true
			end
			ang = ang + math.min(torso.Velocity.magnitude/11, 0.5)
			motor.MaxVelocity = math.min((torso.Velocity.magnitude/111), 0.04) --+ mv
			motor.DesiredAngle = -ang
			if motor.CurrentAngle < -0.2 and motor.DesiredAngle > -0.2 then
				motor.MaxVelocity = 0.04
			end
			repeat task.wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
			if torso.Velocity.magnitude < 0.1 then
				task.wait(0.1)
			end
		until not p or p.Parent ~= torso.Parent
	end

    local vapecapeconnection
	local capeVolume = {Value = 0}
	local capebox = {Value = ""}
    local cape = COB("Render",{
        Name = "Cape",
        HoverText = "Make a cape that is animated",
        Function = function(callback)
            if callback then
				local customlink = capebox["Value"]:split("/")
				local successfulcustom = false
				if #customlink > 0 and capebox["Value"]:len() > 3 then
					if (not betterisfile("vape/assets/"..customlink[#customlink])) then 
						local suc, res = pcall(function() writefile("vape/assets/"..customlink[#customlink], requestfunc({Url=capebox["Value"],Method="GET"}).Body) end)
						if not suc then 
							createwarning("AnimCape", "file failed to download : "..res, 5)
						end
					end
					successfulcustom = true
				end
                vapecapeconnection = lplr.CharacterAdded:connect(function(char)
                    task.spawn(function()
                        pcall(function() 
                            capeFunction(char, getasset("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.webm")), capeVolume["Value"])
                        end)
                    end)
                end)
                if lplr.Character then
                    task.spawn(function()
                        pcall(function() 
                            capeFunction(lplr.Character, getasset("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.webm")), capeVolume["Value"])
                        end)
                    end)
                end
            else
                if vapecapeconnection then
                    vapecapeconnection:Disconnect()
                end
                if lplr.Character then
                    for i,v in pairs(lplr.Character:GetDescendants()) do
                        if v.Name == "AnimCape" then
                            v:Remove()
                        end
                    end
                end
            end
        end
    })
	
	capebox = cape.CreateTextBox({
		Name = "File",
		TempText = "File (link)",
		FocusLost = function(enter) 
			if enter then 
				if cape.Enabled then 
					cape["ToggleButton"](false)
					cape["ToggleButton"](false)
				end
			end
		end
	})
	capeVolume = cape.CreateSlider({
		Name = "Volume",
		Function = function(val) 
			if val then 
				if cape.Enabled then 
					cape["ToggleButton"](false)
					cape["ToggleButton"](false)
				end
			end
		end,
		Min = 0,
		Max = 100,
		Default = 0
	})
end)

runcode(function()
	local downconnection, upconnection

	local function counter()
		local count = 0
		local numbers = {
			"One", "Two", "Three", "Four", "Five",
			"Six", "Seven", "Eight", "Nine"
		}
		return function(num)
			count = count + num
			if count > 9 then
				count = 1
			elseif count < 1 then
				count = 9
			end
			Send(numbers[count])
		end
	end
	local KeyCount = counter()
	COB("Utility",{
		Name = "Force FPS", 
		Function = function(callback)
			if callback then
				lplr.CameraMode = "LockFirstPerson"
				local mouse = lplr:GetMouse()

				local function onWheelBackward()
					KeyCount(-1)
				end
				downconnection = mouse.WheelBackward:Connect(onWheelBackward)

				local function onWheelForward()
					KeyCount(1)
				end
				upconnection = mouse.WheelForward:Connect(onWheelForward)

			else
				lplr.CameraMode = "Classic"
				downconnection:Disconnect()
				upconnection:Disconnect()
			end
		end,
        HoverText = "Locks your camera to first person and allow scrollwheel"
	})
end)

runcode(function()
	local AutobuyWool = {Enabled = false}
	AutobuyWool = COB("Utility", {
		Name = "Auto Buy Wool (shit)",
		HoverText = "Shit needs to be made better sometime",
		Function = function(v)
			if v then
				task.spawn(function()
					repeat
						if (not AutobuyWool.Enabled) then return end
						Client:Get("BedwarsPurchaseItem"):CallServerAsync({["shopItem"] = {["itemType"] = "wool_white"}});
					until (not AutobuyWool.Enabled)
				end)
			end
		end
	})
end)

GuiLibrary["RemoveObject"]("KillEffectOptionsButton")
runcode(function()
	local DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker["kill-effect"].effects["default-kill-effect"])
	local QueryUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).GameQueryUtil

	local oldkilleffect,oldkilltype
	local KillEffect = {Enabled = false}
    local killEffectToggle = {Enabled = false}
	local customKillEffectMode = {Value = "Gravity"}
    local bedwarsKillEffectMode = {}
	local customKilleffects = {
		Gravity = function(p3, p4, p5, p6)
			p5:BreakJoints()
			task.spawn(function()
				local partvelo = {}
				for i,v in pairs(p5:GetDescendants()) do 
					if v:IsA("BasePart") then 
						partvelo[v.Name] = v.Velocity * 3
					end
				end
				p5.Archivable = true
				local clone = p5:Clone()
				clone.Humanoid.Health = 100
				clone.Parent = workspace
				local nametag = clone:FindFirstChild("Nametag", true)
				if nametag then nametag:Destroy() end
				game:GetService("Debris"):AddItem(clone, 30)
				p5:Destroy()
				task.wait(0.01)
				clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				clone:BreakJoints()
				task.wait(0.01)
				for i,v in pairs(clone:GetDescendants()) do 
					if v:IsA("BasePart") then 
						local bodyforce = Instance.new("BodyForce")
						bodyforce.Force = Vector3.new(0, (workspace.Gravity - 10) * v:GetMass(), 0)
						bodyforce.Parent = v
						v.CanCollide = true
						v.Velocity = partvelo[v.Name] or Vector3.zero
					end
				end
			end)
		end,
		Lightning = function(p3, p4, p5, p6)
			p5:BreakJoints()
			local startpos = 1125
			local startcf = p5.PrimaryPart.CFrame.p - Vector3.new(0, 8, 0)
			local newpos = Vector3.new((math.random(1, 10) - 5) * 2, startpos, (math.random(1, 10) - 5) * 2)
			for i = startpos - 75, 0, -75 do 
				local newpos2 = Vector3.new((math.random(1, 10) - 5) * 2, i, (math.random(1, 10) - 5) * 2)
				if i == 0 then 
					newpos2 = Vector3.zero
				end
				local part = Instance.new("Part")
				part.Size = Vector3.new(1.5, 1.5, 77)
				part.Material = Enum.Material.SmoothPlastic
				part.Anchored = true
				part.Material = Enum.Material.Neon
				part.CanCollide = false
				part.CFrame = CFrame.new(startcf + newpos + ((newpos2 - newpos) * 0.5), startcf + newpos2)
				part.Parent = workspace
				local part2 = part:Clone()
				part2.Size = Vector3.new(3, 3, 78)
				part2.Color = Color3.new(0.7, 0.7, 0.7)
				part2.Transparency = 0.7
				part2.Material = Enum.Material.SmoothPlastic
				part2.Parent = workspace
				game:GetService("Debris"):AddItem(part, 0.5)
				game:GetService("Debris"):AddItem(part2, 0.5)
				QueryUtil:setQueryIgnored(part, true)
				QueryUtil:setQueryIgnored(part2, true)
				if i == 0 then 
					local soundpart = Instance.new("Part")
					soundpart.Transparency = 1
					soundpart.Anchored = true 
					soundpart.Size = Vector3.zero
					soundpart.Position = startcf
					soundpart.Parent = workspace
					QueryUtil:setQueryIgnored(soundpart, true)
					local sound = Instance.new("Sound")
					sound.SoundId = "rbxassetid://6993372814"
					sound.Volume = 2
					sound.Pitch = 0.5 + (math.random(1, 3) / 10)
					sound.Parent = soundpart
					sound:Play()
					sound.Ended:Connect(function()
						soundpart:Destroy()
					end)
				end
				newpos = newpos2
			end
		end,
		Ragdoll = function(p3, p4, p5, p6)
			p5:BreakJoints()
			task.spawn(function()
				local partvelo = {}
				for i,v in pairs(p5:GetDescendants()) do 
					if v:IsA("BasePart") then 
						partvelo[v.Name] = v.Velocity * 3
					end
				end
				p5.Archivable = true
				local clone = p5:Clone()
				clone.Humanoid.Health = 100
				clone.Parent = workspace
				local nametag = clone:FindFirstChild("Nametag", true)
				if nametag then nametag:Destroy() end
				game:GetService("Debris"):AddItem(clone, 2)
				p5:Destroy()
				task.wait(0.01)
				clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)

				local m = Instance.new("Model")
				m.Parent = game.Workspace
				game:GetService("Debris"):AddItem(m,10)
				local g = clone:GetChildren()
				clone.HumanoidRootPart.CanCollide = false

				for _, v in pairs(clone:GetDescendants()) do
					if v.Parent == clone then
						v.Parent = m
					end
					if v:IsA("Motor6D") then
						local Att0, Att1 = Instance.new("Attachment"), Instance.new("Attachment")
						Att0.CFrame = v.C0
						Att1.CFrame = v.C1
						Att0.Parent = v.Part0
						Att1.Parent = v.Part1
						local BSC = Instance.new("BallSocketConstraint")
						BSC.Attachment0 = Att0
						BSC.Attachment1 = Att1
						BSC.Parent = v.Part0
						if v.Part1.Name ==  "Head" then
							BSC.LimitsEnabled = true
							BSC.TwistLimitsEnabled = true
						end
						v.Enabled = false
					end
					if v.Name == "AccessoryWeld" then
						local WC = Instance.new("WeldConstraint")
						WC.Part0 = v.Part0
						WC.Part1 = v.Part1
						WC.Parent = v.Parent
						v.Enabled = false
					end
					if v.Name == "Head" and v:IsA("BasePart") then
						v.CanCollide = true
					end
					if v:IsA("BasePart") then
						v.CanCollide = true
						v.Velocity = partvelo[v.Name] or Vector3.zero
					end
				end
			end)
		end,
		Statue = function(p3, p4, p5, p6)
			p5:BreakJoints()
			task.spawn(function()
				local partvelo = {}
				for i,v in pairs(p5:GetDescendants()) do 
					if v:IsA("BasePart") then 
						partvelo[v.Name] = v.Velocity * 3
					end
				end
				p5.Archivable = true
				local clone = p5:Clone()
				clone.Humanoid.Health = 100
				clone.Parent = workspace
				local nametag = clone:FindFirstChild("Nametag", true)
				if nametag then nametag:Destroy() end
				game:GetService("Debris"):AddItem(clone, 2)
				p5:Destroy()
				task.wait(0.01)
				clone.Humanoid:ChangeState(Enum.HumanoidStateType.Dead)
				
				local m = Instance.new("Model")
				m.Parent = game.Workspace
				game:GetService("Debris"):AddItem(m,10)
				local g = clone:GetChildren()
				clone.HumanoidRootPart.CanCollide = false
				
				for _, v in pairs(clone:GetDescendants()) do
					if v.Parent == clone then
						v.Parent = m
					end
					if v:IsA("Motor6D") then
						local Weld = Instance.new("Weld")
						-- Weld.C0 = MainPart.CFrame:toObjectSpace(v.C1.CFrame) --I need to figure out what this was ment to be
						Weld.Part0 = v.C0
						Weld.Part1 = v.C1
						Weld.Parent = v.Parent
						v.Enabled = false
					end
					if v.Name == "AccessoryWeld" then
						local Weld = Instance.new("Weld")
						-- Weld.C0 = MainPart.CFrame:toObjectSpace(v.Part1.CFrame) --I need to figure out what this was ment to be
						Weld.Part0 = v.Part0
						Weld.Part1 = v.Part1
						Weld.Parent = v.Parent
						v.Enabled = false
					end
					if v.Name == "Head" and v:IsA("BasePart") then
						v.CanCollide = true
					end
					if v:IsA("BasePart") then
						v.CanCollide = true
						v.Velocity = partvelo[v.Name] or Vector3.zero
					end
				end
			end)
		end
	}

	KillEffect = COB("Render",{
		Name = "KillEffect",
		Function = function(callback)
			if callback then 
                oldkilltype = lplr:GetAttribute("KillEffectType", "none")
                oldkilleffect = DefaultKillEffect.onKill
                if killEffectToggle.Enabled then
                    lplr:SetAttribute("KillEffectType", "none")
                    DefaultKillEffect.onKill = function(p3, p4, p5, p6)
                        customKilleffects[customKillEffectMode.Value](p3, p4, p5, p6)
                    end
                else
                    lplr:SetAttribute("KillEffectType", bedwarsKillEffectMode.Value)
                end
			else
				DefaultKillEffect.onKill = oldkilleffect
                lplr:SetAttribute("KillEffectType", oldkilltype)
			end
		end
	})

	killEffectToggle = KillEffect.CreateToggle({ -- toggles between custom and bedwars in a kinda bad way
		Name = "Custom kill effect",
		Function = function(tog)
            customKillEffectMode.Object.Visible = tog
            bedwarsKillEffectMode.Object.Visible = not tog
            KillEffect["ToggleButton"](false) KillEffect["ToggleButton"](false)
        end
	})

	customKillEffectMode = KillEffect.CreateDropdown({ -- Lists the custom kill effects
		Name = "Effect",
		Function = function() KillEffect["ToggleButton"](false) KillEffect["ToggleButton"](false) end,
		List = (function() local modes = {} for i,v in pairs(customKilleffects) do  table.insert(modes, i) end table.sort(modes, function(a, b) return tostring(a) < tostring(b) end) return modes end)()
	})

	bedwarsKillEffectMode = KillEffect.CreateDropdown({ -- Litst Bedwar's kill effects
		Name = "Effect",
		Function = function() KillEffect["ToggleButton"](false) KillEffect["ToggleButton"](false) end,
		List = (function() local modes = {} for i,v in pairs(BedwarsKillEffects) do  table.insert(modes, i) end table.sort(modes, function(a, b) return tostring(a) < tostring(b) end) return modes end)()
	})
end)

runcode(function()
	local OfflinePlayerUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).OfflinePlayerUtil
	local LocalPlayerData = OfflinePlayerUtil.getPlayer(lplr);

    COB("Utility",{
        Name = "HostExploit",
		HoverText = "Client Sided",
        Function = function(callback)
            if callback then
				LocalPlayerData:SetAttribute("Cohost", true)
			else
				LocalPlayerData:SetAttribute("Cohost", false)
            end
		end
    })
end)

runcode(function()
	local openChests = {Enabled = false}
	openChests = COB("World",{
		Name = "OpenChests",
		HoverText = "Makes all chests look opened for everyone",
		Function = function(callmeback)
			if callmeback then
				for i,v in pairs(game:GetService("CollectionService"):GetTagged("chest")) do
					task.spawn(function()
						if v:FindFirstChild("ChestFolderValue") then
							local chest = v:FindFirstChild("ChestFolderValue")
							chest = chest and chest.Value or nil
							client:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest) -- Tells the server you opened a chest ig
						end
					end)
				end
				client:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
				if openChests.Enabled then openChests["ToggleButton"](false) end
				createwarning("Chests", "All chests opened!", 10)
			end
		end
	})
end)

runcode(function()
	local OpenDaApps = {Enabled = false}
	local AppSelected = {}
	
	local AppController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController
	OpenDaApps = COB("Utility",{
		Name = "AppOpener",
		HoverText = "Allows you open any \"app\"",
		Function = function(cb)
			if cb then
				OpenDaApps.ToggleButton(false)
				AppController:openApp(AppSelected["Value"], {})
			end
		end
	})

	AppSelected = OpenDaApps.CreateDropdown({
		Name = "App",
		HoverText = "What app to open",
		Function = function() end,
		["List"] = (function() local list = {} for _, value in pairs(BedwarsAppIds) do table.insert(list, value) end table.sort(list, function(a, b) return tostring(a) < tostring(b) end) return list end)()
	})
end)

runcode(function()
	local OfflinePlayerUtil = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out).OfflinePlayerUtil

	local InvAll = {Enabled = false}
	InvAll = COB("Utility",{
		Name = "InvAll",
		HoverText = "Invite all to your party",
		Function = function(cb)
			if cb then
				createwarning("InvAll", "Inviting all.", 10)
				local player
				for i,v in pairs(players:GetChildren()) do
					player = OfflinePlayerUtil.getPlayer(v)
					Flamework.resolveDependency("@easy-games/lobby:client/controllers/party-controller@PartyController"):invitePlayer(player)
					task.wait() -- Don't lag game
				end
				InvAll.ToggleButton(false)
			end
		end
	})
end)

runcode(function()
	-- Hell ya theft is fun
	COB("Utility", {
		Name = "Ban screen",
		HoverText = "Makes ban msgs look like minecraft (by xylex)",
		Function = function(callmeback)
			if callmeback then
				local suc, req = pcall(function() return requestfunc({
					Url = "https://raw.githubusercontent.com/Roblox-Thot/VapeThotMod/"..readfile("vape/RTcommithash.txt").."/scripts/BedwarsKickScreen.lua",
					Method = "GET"
				}) end)
				if suc and req.StatusCode == 200 then loadstring(req.Body)() end
			else
				createwarning("Ban Screen", "Disabled Next Game", 10)
			end
		end
	})
end)

GuiLibrary.RemoveObject("NoBobOptionsButton")
runcode(function()
	-- includes fixes for if BW shows the hands
	-- Other than that I have no idea what any of this does
	local nobobdepth = {Value = 8}
	local nobobhorizontal = {Value = 8}
	local nobobvertical = {Value = -2}
	local rotationx = {Value = 0}
	local rotationy = {Value = 0}
	local rotationz = {Value = 0}
	local VMC = KnitClient.Controllers.ViewmodelController
	local animtype = require(game:GetService("ReplicatedStorage").TS.animation["animation-type"]).AnimationType
	local oldc1
	local nobob = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		Name = "NoBob",
		Function = function(callback) 
			local viewmodel = VMC:getViewModel()
			if viewmodel then
				if callback then
					oldfunc = VMC.playAnimation
					VMC.playAnimation = function(self, animid, details)
						if animid == animtype.FP_WALK then
							return
						end
						return oldfunc(self, animid, details)
					end
					VMC:setHeldItem(lplr.Character and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value and lplr.Character.HandInvItem.Value:Clone())
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", -(nobobdepth.Value / 10))
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (nobobhorizontal.Value / 10))
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", (nobobvertical.Value / 10))
					oldc1 = viewmodel.RightHand.RightWrist.C1
					viewmodel.RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
				else
					VMC.playAnimation = oldfunc
					VMC:setHeldItem(lplr.Character and lplr.Character:FindFirstChild("HandInvItem") and lplr.Character.HandInvItem.Value and lplr.Character.HandInvItem.Value:Clone())
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_DEPTH_OFFSET", 0)
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", 0)
					lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", 0)
					viewmodel.RightHand.RightWrist.C1 = oldc1
				end
			end
		end,
		HoverText = "Makes sword farther"
	})
	nobobhorizontal = nobob.CreateSlider({
		Name = "Horizontal",
		Min = 0,
		Max = 24,
		Default = 8,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_HORIZONTAL_OFFSET", (val / 10))
			end
		end
	})
	nobobvertical= nobob.CreateSlider({
		Name = "Vertical",
		Min = 0,
		Max = 24,
		Default = -2,
		Function = function(val)
			if nobob.Enabled then
				lplr.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-controller"]:SetAttribute("ConstantManager_VERTICAL_OFFSET", (val / 10))
			end
		end
	})
	rotationx = nobob.CreateSlider({
		Name = "RotX",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				KnitClient.Controllers.ViewmodelController:getViewModel().RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationy = nobob.CreateSlider({
		Name = "RotY",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				KnitClient.Controllers.ViewmodelController:getViewModel().RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
	rotationz = nobob.CreateSlider({
		Name = "RotZ",
		Min = 0,
		Max = 360,
		Function = function(val)
			if nobob.Enabled then
				KnitClient.Controllers.ViewmodelController:getViewModel().RightHand.RightWrist.C1 = oldc1 * CFrame.Angles(math.rad(rotationx.Value), math.rad(rotationy.Value), math.rad(rotationz.Value))
			end
		end
	})
end)

runcode(function()
	local right = {
		"RightUpperArm",
		"RightLowerArm",
		"RightHand"
	}

	showArms = COB("Render", {
		Name = "Show hand",
		HoverText = "Shows hand right hand",
		Function = function(callmeback)
			if callmeback then
				for i, v in pairs(KnitClient.Controllers.ViewmodelController:getViewModel():GetChildren()) do
					if table.find(right, v.Name) ~= nil then
						v.Transparency = 0 -- Shows the parts
					end
				end
				for i,v in pairs(lplr.Character:GetDescendants()) do
					if v:IsA("Clothing") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
						v:Clone().Parent = KnitClient.Controllers.ViewmodelController:getViewModel() -- Clones shirt and body colors to the view model
					end
				end
			else
				for i, v in pairs(KnitClient.Controllers.ViewmodelController:getViewModel():GetChildren()) do
					if table.find(right, v.Name) ~= nil then
						v.Transparency = 1 -- Hides Parts
					elseif v:IsA("Clothing") or v:IsA("ShirtGraphic") or v:IsA("BodyColors") then
						v:Destroy() -- makes viewmodel nakie
					end
				end
			end
		end
	})
end)

--[[ Just use Inf Fly
runcode(function()
	local entity = shared.vapeentity
	local yeetOut = {Enabled = false}
	local ypowerbitch, kSwitch
	yeetOut = COB("Blatant", {
		Name = "Yeet",
		HoverText = "Yeets into space (can kill you 💀)",
		Function = function(callmeback)
			if callmeback then
				module = GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]
				if module then
					if module["Api"].Enabled == false then
						createwarning("Yeet away","Auto turning on Speed\nas it is needed!", 10)
						module["Api"]["ToggleButton"]()
					end
				end

				createwarning("Yeet away","This bitch empty.", 10)
                repeat
                    task.wait()
                    entity.character.HumanoidRootPart.Velocity = Vector3.new(math.huge, tonumber(ypowerbitch["Value"]), math.huge)
                until (kSwitch.Enabled) or (not entity.isAlive)

                if yeetOut.Enabled then yeetOut["ToggleButton"](false) end
                if kSwitch.Enabled then kSwitch["ToggleButton"](false) end
				-- yeetOut["ToggleButton"](false)
			end
		end
	})
	-- Is this jank way to do this?
	-- Yes
	-- Am I going to redo this
	-- No
	ypowerbitch = yeetOut.CreateSlider({
		Name = "Y Powwa",
		Function = function()end,
		Min = 10000000,
		Max = 99999999,
		Default = 6942069
	})
	
	kSwitch = yeetOut.CreateToggle({
		Name = "Kill switch",
        HoverText = "Makes it stop tping you up",
		Function = function()end,
		Default = false
	})
end)
]]

--[[
runcode(function()
	-- Only here because I'm lazy and use it sometimes
	COB("Utility", {
		Name = "Inf Yield",
		HoverText = "Load infiniteyield",
		Function = function(callmeback)
			if callmeback then
				loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
			else
				createwarning("InfYield", "Will no longer auto run", 10)
			end
		end
	})
end)
]]

--[[ redundent now (UICleanup)
runcode(function()
	local CoreGuiToggle = {Enabled = false}
					
	local StarterGui = game:GetService("StarterGui")

	local coreGuiTypeNames = {
		leaderboard = Enum.CoreGuiType.PlayerList,
		chat = Enum.CoreGuiType.Chat,
		emotes = Enum.CoreGuiType.EmotesMenu,
	}

	local defaultToggles = (function() local save = {} for name, enum in pairs(coreGuiTypeNames) do save[name] = StarterGui:GetCoreGuiEnabled(enum) end return save end)()

	local typeToggles = {}

	CoreGuiToggle = COB("Render", {
		Name = "CoreGuiToggle",
		HoverText = "Toggles for coreGui stuff",
		Function = function(callmeback)
			if callmeback then
				for name, toggle in pairs(typeToggles) do
					StarterGui:SetCoreGuiEnabled(coreGuiTypeNames[name], toggle.Enabled) -- Sets each GUI type to what you set
				end
			else
				for name, toggle in pairs(typeToggles) do
					StarterGui:SetCoreGuiEnabled(coreGuiTypeNames[name], defaultToggles[name]) -- hopefuly esets it to what it was
				end
			end
		end
	})

	for name, enum in pairs(coreGuiTypeNames) do
		typeToggles[name] = CoreGuiToggle.CreateToggle({ -- Loops through the CoreGuis and makes a button for each
			Name = string.gsub(name, "^%l", function(c) return string.upper(c) end),
			HoverText = "Toggles the "..name,
			Function = function(state)
				if CoreGuiToggle.Enabled then
					StarterGui:SetCoreGuiEnabled(enum, state)
				end
			end,
			Default = false
		})
	end
end)
]]--

--[[ To be rewritten
runcode(function()
	local showArms, hideLeft = {Enabled = false}
	local CS = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.ui.store).ClientStore
	local ViewmodelMode = require(game:GetService("Players").LocalPlayer.PlayerScripts.TS.controllers.global.viewmodel["viewmodel-mode"]).ViewmodelMode
	math.randomseed(tick())

	showArms = COB("Render", {
		Name = "Show hands",
		HoverText = "Shows hands and enables bob in fistperson",
		Function = function(callmeback)
			if callmeback then
				KnitClient.Controllers.ViewmodelController:setViewModelMode(ViewmodelMode.SHOW_ARMS);
				local number = math.random(1, 8)
				local hotbarSlot = CS:getState().Inventory.observedInventory.hotbarSlot
				if number == hotbarSlot +1 then
					number = number + 1
				end
				
				local numbers = {
					"One", "Two", "Three", "Four", "Five",
					"Six", "Seven", "Eight", "Nine"
				}
				Send(numbers[number])
				task.wait(0.02)
				Send(numbers[hotbarSlot+1])

				if hideLeft.Enabled or hideRight.Enabled then
					-- local left = {
					-- 	"LeftUpperArm",
					-- 	"LeftLowerArm",
					-- 	"LeftHand"
					-- }
					-- local right = {
					-- 	"RightUpperArm",
					-- 	"RightLowerArm",
					-- 	"RightHand"
					-- }
					for i, v in pairs(KnitClient.Controllers.ViewmodelController:getViewModel():GetChildren()) do
						if table.find(left, v.Name) ~= nil and hideLeft.Enabled then
							v.Transparency = 1
						elseif table.find(right, v.Name) ~= nil and hideRight.Enabled then
							v.Transparency = 1
						end
					end
				end
			else
				KnitClient.Controllers.ViewmodelController:setViewModelMode(ViewmodelMode.HIDE_ARMS);
			end
		end
	})
	
	hideLeft = showArms.CreateToggle({
		Name = "Hide left",
		HoverText = "Hides your left arm. Usefull for 'nobob' movements",
		Function = function(state)
			-- local left = {
			-- 	"LeftUpperArm",
			-- 	"LeftLowerArm",
			-- 	"LeftHand"
			-- }
			for i, v in pairs(KnitClient.Controllers.ViewmodelController:getViewModel():GetChildren()) do
				if table.find(left, v.Name) ~= nil then
					if hideLeft.Enabled then
						v.Transparency = 1
					else
						v.Transparency = 0
					end
				end
			end
		end,
		Default = false
	})
	
	hideRight = showArms.CreateToggle({
		Name = "Hide right",
		HoverText = "Hides your right arm. Usefull for 'nobob' movements",
		Function = function(state)
			-- local right = {
			-- 	"RightUpperArm",
			-- 	"RightLowerArm",
			-- 	"RightHand"
			-- }
			for i, v in pairs(KnitClient.Controllers.ViewmodelController:getViewModel():GetChildren()) do
				if table.find(right, v.Name) ~= nil then
					if hideLeft.Enabled then
						v.Transparency = 1
					else
						v.Transparency = 0
					end
				end
			end
		end,
		Default = false
	})
end)
]]--

--[[ patched in new chat
runcode(function()
	pcall(function()
		if not clonefunction and not type(clonefunction) == "function" then
			function CloneFunction(f)
				local lol = xpcall(setfenv, function(a,b)
					return a,b
				end, f, getfenv(f))
				if lol then
					return function(...)
						return f(...)
					end
				end
				return coroutine.wrap(function(...)
					while true do
						f = coroutine.yield(f(...))
					end
				end)
			end
		else
			CloneFunction = clonefunction
		end
		if game:GetService("TextChatService").ChatVersion == Enum.ChatVersion.TextChatService then return end -- If they update the chat this wont work so this will prevent it from showing up :epic:
		local CheckCaller = CloneFunction(checkcaller)
		local HookFunction = CloneFunction(hookfunction)
		local PostMessage = require(lplr:WaitForChild("PlayerScripts"):WaitForChild("ChatScript"):WaitForChild("ChatMain")).MessagePosted
		local MessageEvent = Instance.new("BindableEvent")

		local OldFunctionHook

		COB("Utility", {
			Name = "AntiLog",
			HoverText = "Attempts to stop Roblox from logging chat",
			Function = function(callmeback)
				if callmeback then
					local PostMessageHook = function(self, msg)
						if not CheckCaller() and self == PostMessage then
							MessageEvent:Fire(msg)
							return
						end
						return OldFunctionHook(self, msg)
					end
					OldFunctionHook = HookFunction(PostMessage.fire, PostMessageHook)
					print("Hooked me bbg")
				else
					HookFunction(PostMessage.fire, OldFunctionHook) -- Revert? idk, idc, just keep it on
					print("Unhooked... why?")
				end
			end
		})
	end)
end)
]]--