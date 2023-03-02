local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local connections = {}
local repstorage = game:GetService("ReplicatedStorage")

oldhmmi = hookmetamethod(game, "__index", function(self, method)
	if self == lpr and method:lower() == "kick" then
		return error("Expected ':' not '.' calling member function Kick", 2)
	end
	return oldhmmi(self, method)
end)
oldhmmnc = hookmetamethod(game, "__namecall", function(self, ...)
	if self == lpr and getnamecallmethod():lower() == "kick" then
		return
	end
	return oldhmmnc(self, ...)
end)

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
		spawn(function()
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
			textlabel:Remove()
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
	-- disables Vape Private checks (KEKW he saw my github)
	-- local regex = 'commands%.kill == nil'
	-- local repin =  "false"
	-- local clean = string.gsub(tostring(publicrepo), regex,repin)
	
	-- -- disables Vape Private user commands
	-- regex = 'local vapePrivateCommands = {.*local AutoReport = {'
	-- repin =  "local vapePrivateCommands = {} local AutoReport = {"
	-- clean = string.gsub(tostring(clean), regex,repin)
	
	-- -- attempts to give lplr admin (CLIENT SIDED)
	-- regex = 'WhitelistFunctions:CheckPlayerType%(lplr%) ~= "DEFAULT"'
	-- repin = "true"
	-- clean = string.gsub(tostring(clean), regex,repin)
	-- regex = 'priolist%[WhitelistFunctions:CheckPlayerType%(lplr%)%] > 0'
	-- repin = "true"
	-- clean = string.gsub(tostring(clean), regex,repin)
	
	-- -- removes bedwarsdata kicks
	-- regex = 'newdatatab%.KickUsers%[tostring%(lplr%.UserId%)%]'
	-- repin = "false"
	-- clean = string.gsub(tostring(clean), regex,repin)
	-- regex = 'datatab%.KickUsers%[tostring%(lplr%.UserId%)%]'
	-- repin = "false"
	-- clean = string.gsub(tostring(clean), regex,repin)
	
	-- -- makes you look like you use rektsky to vp users
	-- regex = '%.%.clients%.ChatStrings2%.vape'
	-- repin = "..clients.ChatStrings2.rektsky"
	-- clean = string.gsub(tostring(clean), regex,repin)
    loadstring(publicrepo)()
end

local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework
local BedwarsAppIds = require(game:GetService("StarterPlayer").StarterPlayerScripts.TS.ui.types["app-config"])["BedwarsAppIds"]

GuiLibrary["SelfDestructEvent"].Event:Connect(function()
	for i3,v3 in pairs(connections) do
		if v3.Disconnect then pcall(function() v3:Disconnect() end) end
		if v3.disconnect then pcall(function() v3:disconnect() end) end
	end
end)

local function AnimCape(char, texture, vol)
	local hum = char:WaitForChild("Humanoid")
	local torso = nil
	if hum.RigType == Enum.HumanoidRigType.R15 then
		torso = char:WaitForChild("UpperTorso")
	else
		torso = char:WaitForChild("Torso")
	end
	local p = Instance.new("Part", torso.Parent)
	p.Name = "AnimCape"
	p.Anchored = false
	p.CanCollide = false
	p.TopSurface = 0
	p.BottomSurface = 0
	p.FormFactor = "Custom"
	p.Size = Vector3.new(1.8, 3.5, 0.001)
	p.Transparency = 1
	local SG = Instance.new("SurfaceGui", p)
	SG.Face = "Back"
	local VF = Instance.new("VideoFrame", SG)
	VF.Video = texture
	VF.Size = UDim2.new(1, 0, 1, 0)
	VF.Looped = true
	VF:Play()
	VF.Volume = vol/100
	
	local motor = Instance.new("Motor", p)
	motor.Part0 = p
	motor.Part1 = torso
	motor.MaxVelocity = 0.01
	motor.C0 = CFrame.new(0,2,0) * CFrame.Angles(0,math.rad(90),0)
	motor.C1 = CFrame.new(0,1,0.45) * CFrame.Angles(0,math.rad(90),0)
	local wave = true

	-- Hide in FirstPerson
	spawn(function()
		repeat wait(1/44)
			data = (workspace.Camera.CFrame.Position - workspace.Camera.Focus.Position).Magnitude
			if data-0.51 <= 0 then 
				VF.Visible = false
			else 
				VF.Visible = true
			end
		until not p or p.Parent ~= torso.Parent
	end)

	repeat wait(1/44)
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
		repeat wait() until motor.CurrentAngle == motor.DesiredAngle or math.abs(torso.Velocity.magnitude - oldmag) >= (torso.Velocity.magnitude/10) + 1
		if torso.Velocity.magnitude < 0.1 then
			wait(0.1)
		end
	until not p or p.Parent ~= torso.Parent
end

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

runcode(function()
    local vapecapeconnection
	local animCapeVolume = {["Value"] = 0}
	local animCapebox = {["Value"] = ""}
    local animCape = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "AnimatedCapeBeta",
        ["HoverText"] = "Make a cape that is animated",
        ["Function"] = function(callback)
            if callback then
				local customlink = animCapebox["Value"]:split("/")
				local successfulcustom = false
				if #customlink > 0 and animCapebox["Value"]:len() > 3 then
					if (not betterisfile("vape/assets/"..customlink[#customlink])) then 
						local suc, res = pcall(function() writefile("vape/assets/"..customlink[#customlink], requestfunc({Url=animCapebox["Value"],Method="GET"}).Body) end)
						if not suc then 
							createwarning("AnimCape", "file failed to download : "..res, 5)
						end
					end
					successfulcustom = true
				end
                vapecapeconnection = lplr.CharacterAdded:connect(function(char)
                    task.spawn(function()
                        pcall(function() 
                            AnimCape(char, getasset("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.webm")), animCapeVolume["Value"])
                        end)
                    end)
                end)
                if lplr.Character then
                    task.spawn(function()
                        pcall(function() 
                            AnimCape(lplr.Character, getasset("vape/assets/"..(successfulcustom and customlink[#customlink] or "VapeCape.webm")), animCapeVolume["Value"])
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
	
	animCapebox = animCape.CreateTextBox({
		["Name"] = "File",
		["TempText"] = "File (link)",
		["FocusLost"] = function(enter) 
			if enter then 
				if animCape["Enabled"] then 
					animCape["ToggleButton"](false)
					animCape["ToggleButton"](false)
				end
			end
		end
	})
	animCapeVolume = animCape.CreateSlider({
		["Name"] = "Volume",
		["Function"] = function(val) 
			if val then 
				if animCape["Enabled"] then 
					animCape["ToggleButton"](false)
					animCape["ToggleButton"](false)
				end
			end
		end,
		["Min"] = 0,
		["Max"] = 100,
		["Default"] = 0
	})
end)

runcode(function()
	local Send = function(Key)
		local VM = game:GetService('VirtualInputManager')
		VM:SendKeyEvent(true,Enum.KeyCode[Key],false,game)
		VM:SendKeyEvent(false,Enum.KeyCode[Key],false,game)
	end

	function counter()
		local count = 0
		local numbers = {
		  "One", "Two", "Three", "Four", "Five",
		  "Six", "Seven", "Eight", "Nine"
		}
		return function(num)
		  count = count + num
		  if count > 9 then
			count = 1
		  elseif count < 0 then
			count = 9
		  end
		  Send(numbers[count])
		end
	end
	local KeyCount = counter()
	COB("Utility",{
		["Name"] = "Force FPS", 
		["Function"] = function(callback)
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
        ["HoverText"] = "Locks your camera to first person and allow scrollwheel"
	})
end)

runcode(function()
	-- shitty because it's calling the remote and not the module
	COB("Utility", {
		["Name"] = "Auto Buy Wool (shit)",
		["HoverText"] = "Shit needs to be made better sometime",
		["Function"] = function(v)
			AutobuyWool = v
			if AutobuyWool then
				spawn(function()
					repeat
						if (not AutobuyWool) then return end
						repstorage["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"].BedwarsPurchaseItem:InvokeServer({["shopItem"] = {["itemType"] = "wool_white"}})
					until (not AutobuyWool)
				end)
			end
		end
	})
end)

-- Simi-patched
runcode(function()
	local entity = shared.vapeentity
	yeetOut = COB("Blatant", {
		["Name"] = "Yeet",
		["HoverText"] = "Yeets into space (reset to turn off 💀)",
		["Function"] = function(callmeback)
			if callmeback then
				module = GuiLibrary["ObjectsThatCanBeSaved"]["SpeedOptionsButton"]
				if module then
					if module["Api"]["Enabled"] == false then
						createwarning("Yeet away","Auto turning on Speed\nas it is needed!", 10)
						module["Api"]["ToggleButton"]()
					end
				end

				spawn(function()
					repeat
						task.wait()
						entity.character.HumanoidRootPart.Velocity = Vector3.new(math.huge, tonumber(ypowerbitch["Value"]), math.huge)
					until (not entity.isAlive)
				end)

				yeetOut["ToggleButton"](false)
				createwarning("Yeet away","This bitch empty.\n(Reset to go to normal,\nmight need deathtp)", 10)
			end
		end
	})
	-- don't do small numbers you need to go up fast!
	ypowerbitch = yeetOut.CreateSlider({
		["Name"] = "Y Powwa",
		["Function"] = function()end,
		["Min"] = 0,
		["Max"] = 99999999,
		["Default"] = 6942069
	})
end)

runcode(function()
	COB("Utility", {
		["Name"] = "Inf Yield",
		["HoverText"] = "Load infiniteyield",
		["Function"] = function(callmeback)
			if callmeback then
				loadstring(game:HttpGet('https://raw.githubusercontent.com/EdgeIY/infiniteyield/master/source'))()
			else
				createwarning("InfYield", "Will no longer auto run", 10)
			end
		end
	})
end)

runcode(function()
	local entity = shared.vapeentity
	chatLog = COB("Utility", {
		["Name"] = "AntiLog",
		["HoverText"] = "Attempts to stop Roblox from logging chat",
		["Function"] = function(callmeback)
			if callmeback then
				task.spawn(function()
					local ChatChanged = false
					local OldSetting = nil
					local WhitelistedCoreTypes = {
						"Chat",
						"All",
						Enum.CoreGuiType.Chat,
						Enum.CoreGuiType.All
					}
					
					local StarterGui = game:GetService("StarterGui")
					
					local FixCore = function(x)
						local CoreHook; CoreHook = hookmetamethod(x, "__namecall", function(self, ...)
							local Method = getnamecallmethod()
							local Arguments = {...}
							
							if self == x and Method == "SetCoreGuiEnabled" and not checkcaller() then
								local CoreType = Arguments[1]
								local Enabled = Arguments[2]
								
								if table.find(WhitelistedCoreTypes, CoreType) and not Enabled then
									if CoreType == ("Chat" or Enum.CoreGuiType.Chat) then
										OldSetting = Enabled
									end
									ChatChanged = true
								end
							end
							
							return CoreHook(self, ...)
						end)
						
						x.CoreGuiChangedSignal:Connect(function(Type)
							if table.find(WhitelistedCoreTypes, Type) and ChatChanged then
								task.wait()
								if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
									x:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
								end
								wait(1)
								if StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
									x:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, OldSetting) -- probably defaults to false i am too tired for the making of this lol
								end
								ChatChanged = false
							end
						end)
					end
					
					if StarterGui then
						FixCore(StarterGui)
						if not StarterGui:GetCoreGuiEnabled(Enum.CoreGuiType.Chat) then
							StarterGui:SetCoreGuiEnabled(Enum.CoreGuiType.Chat, true)
						end
					else
						local Connection; Connection = game.ChildAdded:Connect(function(x)
							if x:IsA("StarterGui") then
								FixCore(x)
								Connection:Disconnect()
							end
						end)
					end
					
					if not game:IsLoaded() then
						game.Loaded:wait()
					end
					
					local CoreGui = game:GetService("CoreGui")
					local TweenService = game:GetService("TweenService")
					local Players = game:GetService("Players")
					
					local Player = Players.LocalPlayer
					
					local PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui") do
						if not PlayerGui then
							repeat task.wait() until Player:FindFirstChildWhichIsA("PlayerGui")
							PlayerGui = Player:FindFirstChildWhichIsA("PlayerGui")
						end
					end
					
					local PlayerScripts = Player:WaitForChild("PlayerScripts")
					local ChatMain = PlayerScripts:FindFirstChild("ChatMain", true) or false
					
					if not ChatMain then
						local Timer = tick()
						repeat
							task.wait()
						until PlayerScripts:FindFirstChild("ChatMain", true) or tick() > (Timer + 3)
						ChatMain = PlayerScripts:FindFirstChild("ChatMain", true)
					end
					
					local PostMessage = require(ChatMain).MessagePosted
					
					local MessageEvent = Instance.new("BindableEvent")
					local OldFunctionHook
					OldFunctionHook = hookfunction(PostMessage.fire, function(self, Message)
						if not checkcaller() and self == PostMessage then
							MessageEvent:Fire(Message)
							return
						end
						return OldFunctionHook(self, Message)
					end)
					
					if setfflag then
						setfflag("AbuseReportScreenshot", "False")
						setfflag("AbuseReportScreenshotPercentage", "0")
					end
					
					if OldSetting then
						StarterGui:SetCoreGuiEnabled(CoreGuiSettings[1], CoreGuiSettings[2])
					end
				end)
			else
				createwarning("AntiLog", "Disabled Next Game", 10)
			end
		end
	})
end)

runcode(function()
	local Keystrokes = GuiLibrary.CreateCustomWindow({
		["Name"] = "Keystrokes", 
		["Icon"] = "vape/assets/keyboard.png", -- currently you have to use vape assets for icons, this may change in the future
		["IconSize"] = 16, -- size in width to not look ugly
	})
	
    task.spawn(function()
        local ts = game:GetService("TweenService")
        local main4 = Instance.new("Frame")
        main4.BackgroundTransparency = 1
        main4.Size = UDim2.new(0, 195, 0, 205)
        main4.Position = UDim2.new(0.02, 0, 0.127, 0)
        main4.BorderSizePixel = 0
        main4.Parent = Keystrokes.GetCustomChildren()
        local w = Instance.new("TextLabel")
        w.BackgroundColor3 = Color3.fromHSV(1, 0, 0)
        w.BackgroundTransparency = 0.5
        w.BorderSizePixel = 0
        w.Size = UDim2.new(0, 65, 0, 65)
        w.Position = UDim2.new(0.333, 0, 0, 0)
        w.Text = "W"
        w.Font = Enum.Font.GothamMedium
        w.TextSize = 28
        w.TextTransparency = 0.2
        w.TextColor3 = Color3.fromRGB(255, 255, 255)
        Instance.new("UICorner", w)
        w.Parent = main4
        local a = w:Clone()
        a.Text = "A"
        a.Position = UDim2.new(0, 0, 0.317, 0)
        a.Parent = main4
        local s = w:Clone()
        s.Text = "S"
        s.Position = UDim2.new(0.333, 0, 0.317, 0)
        s.Parent = main4
        local d = w:Clone()
        d.Text = "D"
        d.Position = UDim2.new(0.667, 0, 0.317, 0)
        d.Parent = main4
        local space = w:Clone()
        space.Size = UDim2.new(0, 195, 0, 30)
        space.Position = UDim2.new(0, 0, 0.678, 0)
        space.Text = "SPACE"
        space.Parent = main4

		color = Color3.fromHSV(0,0,0)
		w.BackgroundColor3 = color
		a.BackgroundColor3 = color
		s.BackgroundColor3 = color
		d.BackgroundColor3 = color
		space.BackgroundColor3 = color

		Keystrokes.GetCustomChildren().Parent:GetPropertyChangedSignal("Size"):Connect(function()
			main4.Position = UDim2.new(0, 0, 0, (Keystrokes.GetCustomChildren().Parent.Size.Y.Offset == 0 and 45 or 0))
		end)
        
        Keystrokes["Bypass"] = true

        connections[#connections+1] = game:GetService("UserInputService").InputBegan:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                ts:Create(w, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            elseif input.KeyCode == Enum.KeyCode.A then
                ts:Create(a, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            elseif input.KeyCode == Enum.KeyCode.S then
                ts:Create(s, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            elseif input.KeyCode == Enum.KeyCode.D then
                ts:Create(d, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            elseif input.KeyCode == Enum.KeyCode.Space then
                ts:Create(space, TweenInfo.new(0.5), {BackgroundTransparency = 0}):Play()
            end
        end)
        connections[#connections+1] = game:GetService("UserInputService").InputEnded:Connect(function(input)
            if input.KeyCode == Enum.KeyCode.W then
                ts:Create(w, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            elseif input.KeyCode == Enum.KeyCode.A then
                ts:Create(a, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            elseif input.KeyCode == Enum.KeyCode.S then
                ts:Create(s, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            elseif input.KeyCode == Enum.KeyCode.D then
                ts:Create(d, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            elseif input.KeyCode == Enum.KeyCode.Space then
                ts:Create(space, TweenInfo.new(0.5), {BackgroundTransparency = 0.5}):Play()
            end
        end)
    end)

	GuiLibrary["ObjectsThatCanBeSaved"]["GUIWindow"]["Api"].CreateCustomToggle({
		["Name"] = "Keystrokes", 
		["Icon"] = "vape/assets/keyboard.png", 
		["Function"] = function(callback)
			Keystrokes.SetVisible(callback) 
		end, 
		["Priority"] = 3
	})
end)


GuiLibrary["RemoveObject"]("KillEffectOptionsButton")
runcode(function()
	DefaultKillEffect = require(lplr.PlayerScripts.TS.controllers.game.locker["kill-effect"].effects["default-kill-effect"])

	local oldkilleffect
	local killdatboy = GuiLibrary["ObjectsThatCanBeSaved"]["RenderWindow"]["Api"].CreateOptionsButton({
		["Name"] = "KillEffect",
		["Function"] = function(callback)
			if callback then
				if deathselected["Value"] == "Classic Vape" then
					lplr:SetAttribute("KillEffectType", "none")
					oldkilleffect = DefaultKillEffect.onKill
					DefaultKillEffect.onKill = function(p3, p4, p5, p6)
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
					end
				elseif deathselected["Value"] == "Ragdoll" then
					DefaultKillEffect.onKill = function(p3, p4, p5, p6)
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
					end
				elseif deathselected["Value"] == "Statue" then
					DefaultKillEffect.onKill = function(p3, p4, p5, p6)
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
									Weld.C0 = MainPart.CFrame:toObjectSpace(v.C1.CFrame)
									Weld.Part0 = v.C0
									Weld.Part1 = v.C1
									Weld.Parent = v.Parent
									v.Enabled = false
								end
								if v.Name == "AccessoryWeld" then
									local Weld = Instance.new("Weld")
									Weld.C0 = MainPart.CFrame:toObjectSpace(v.Part1.CFrame)
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
				end
			else
				DefaultKillEffect.onKill = oldkilleffect
			end
		end
	})

	deathselected = killdatboy.CreateDropdown({
		["Name"] = "Effect",
		["Function"] = function(cbt) if cbt then  if killdatboy["Enabled"] then  killdatboy["ToggleButton"](false) killdatboy["ToggleButton"](false) end end end,
		["List"] = {"Classic Vape", "Ragdoll", "Statue"}
	})
end)

runcode(function()
	local Host = {["Enabled"] = false}
	
	local v2 = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out)
	local OfflinePlayerUtil = v2.OfflinePlayerUtil
	local v6 = OfflinePlayerUtil.getPlayer(lplr);

    Host = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
        ["Name"] = "HostExploit",
		["HoverText"] = "Client Sided",
        ["Function"] = function(callback)
            if callback then
				v6:SetAttribute("Cohost", true)
			else
				v6:SetAttribute("Cohost", false)
            end
		end
    })
end)

runcode(function()
	Chest = GuiLibrary["ObjectsThatCanBeSaved"]["WorldWindow"]["Api"].CreateOptionsButton({
		["Name"] = "OpenChests",
		["HoverText"] = "Makes all chests look opened for everyone",
		["Function"] = function(callmeback)
			if callmeback then
				local client = require(repstorage.TS.remotes).default.Client
				for i,v in pairs(game:GetService("CollectionService"):GetTagged("chest")) do
					task.spawn(function()
						if v:FindFirstChild("ChestFolderValue") then
							local chest = v:FindFirstChild("ChestFolderValue")
							chest = chest and chest.Value or nil
							local chestitems = chest and chest:GetChildren() or {}
							if #chestitems > 0 then
								client:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(chest)
							end
						end
					end)
				end
				client:GetNamespace("Inventory"):Get("SetObservedChest"):SendToServer(nil)
				Chest["ToggleButton"](false)
				createwarning("Chests", "All chests opened!", 10)
			end
		end
	})
end)

runcode(function()
	local OpenDaApps = {["Enabled"] = false}
	
	local AppController = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out.client.controllers["app-controller"]).AppController
	OpenDaApps = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "AppOpener",
		["HoverText"] = "Allows you open any \"app\"",
		["Function"] = function(cb)
			if cb then
				OpenDaApps.ToggleButton(false)
				AppController:openApp(AppSelected["Value"], {})
			end
		end
	})

	AppSelected = OpenDaApps.CreateDropdown({
		["Name"] = "App",
		["HoverText"] = "What app to open",
		["Function"] = function() end,
		["List"] = (function() local list = {} for _, value in pairs(BedwarsAppIds) do table.insert(list, value) end table.sort(list, function(a, b) return tostring(a) < tostring(b) end) return list end)()
	})
end)

runcode(function()
	local v2 = require(repstorage["rbxts_include"]["node_modules"]["@easy-games"]["game-core"].out)
	local OfflinePlayerUtil = v2.OfflinePlayerUtil
	local Flamework = require(repstorage["rbxts_include"]["node_modules"]["@flamework"].core.out).Flamework

	local InvAll = {["Enabled"] = false}
	InvAll = GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "InvAll",
		["HoverText"] = "Invite all to your party",
		["Function"] = function(cb)
			if cb then
				InvAll.ToggleButton(false)
				createwarning("InvAll", "Inviting all.", 10)
				for i,v in pairs(players:GetChildren()) do
					player = OfflinePlayerUtil.getPlayer(v)
					Flamework.resolveDependency("@easy-games/lobby:client/controllers/party-controller@PartyController"):invitePlayer(player)
					task.wait() -- Don't lag game
				end
			end
		end
	})
end)

