local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end
local connections = {}

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local checkpublicreponum = 0
local checkpublicrepo
checkpublicrepo = function()
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/6872274481.lua",
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
	-- disables and Vape Private user commands
	local regex = 'local commands = {.*local AutoReport = {'
	local repin =  "local commands = {} local AutoReport = {"
	local clean = string.gsub(tostring(publicrepo), regex,repin)
	
	-- attempts to give lplr admin (CLIENT SIDED)
	local Aregex = 'WhitelistFunctions:CheckPlayerType%(lplr%) ~= "DEFAULT"'
	local Arepin = "true"
	local admind = string.gsub(tostring(clean), Aregex,Arepin)
	local Aregex = 'priolist%[WhitelistFunctions:CheckPlayerType%(lplr%)%] > 0'
	local Arepin = "true"
	local admind = string.gsub(tostring(admind), Aregex,Arepin)
	
	-- removes bedwarsdata kicks
	local Kregex = 'newdatatab%.KickUsers%[tostring%(lplr%.UserId%)%]'
	local Krepin = "false"
	local Fclean = string.gsub(tostring(admind), Kregex,Krepin)
	local Kregex = 'datatab%.KickUsers%[tostring%(lplr%.UserId%)%]'
	local Krepin = "false"
	local Fclean = string.gsub(tostring(Fclean), Kregex,Krepin)
	
	-- makes you look like you use rektsky
	local Kregex = '%.%.clients%.ChatStrings2%.vape'
	local Krepin = "..clients.ChatStrings2.rektsky"
	local Fclean = string.gsub(tostring(Fclean), Kregex,Krepin)
    loadstring(Fclean)()
end

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
						game:GetService("ReplicatedStorage")["rbxts_include"]["node_modules"]["@rbxts"].net.out["_NetManaged"].BedwarsPurchaseItem:InvokeServer({["shopItem"] = {["itemType"] = "wool_white"}})
					until (not AutobuyWool)
				end)
			end
		end
	})
end)

runcode(function()
	local entity = shared.vapeentity
	yeetOut = COB("Blatant", {
		["Name"] = "Yeet",
		["HoverText"] = "Yeets into space (reset to turn off ????)",
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
		["Max"] = 9999999,
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
	local entity = shared.vapeentity
	COB("Utility", {
		["Name"] = "AntiIdle",
		["HoverText"] = "Attempts to stop Roblox kicking you for being idle",
		["Function"] = function(callmeback)
			if callmeback then
				task.spawn(function()
					lplr.Idled:connect(function()
						game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
						wait(1)
						game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
					end)
				end)
			else
				createwarning("AntiIdle", "Disabled Next Game", 10)
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
--[[
    local KeyColor = Keystrokes.CreateColorSlider({
        ["Name"] = "Player Color", 
        ["Function"] = function(cbt)
        end
    })

    local KeySat = Keystrokes.CreateSlider({
        ["Name"] = "Sat", -- name of object
        ["Min"] = 0,
        ["Max"] = 100,
        ["Function"] = function(CBT)end,
        ["HoverText"] = "Idk", -- text that will show up after hovering over the button (optional)
        ["Default"] = 100 -- default value (optional)
    })

    local KeyValue = Keystrokes.CreateSlider({
        ["Name"] = "Brightness Value", -- name of object
        ["Min"] = 0,
        ["Max"] = 100,
        ["Function"] = function(CBT)end,
        ["HoverText"] = "Idk", -- text that will show up after hovering over the button (optional)
        ["Default"] = 100 -- default value (optional)
    })
]]--
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

        
        connections[#connections+1] = game:GetService("RunService").RenderStepped:Connect(function(input)
            --color = Color3.fromHSV(KeyColor["Value"],(KeySat["Value"]/100),(KeyValue["Value"]/100))
            color = Color3.fromHSV(0,0,0)
            w.BackgroundColor3 = color
            a.BackgroundColor3 = color
            s.BackgroundColor3 = color
            d.BackgroundColor3 = color
            space.BackgroundColor3 = color
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
