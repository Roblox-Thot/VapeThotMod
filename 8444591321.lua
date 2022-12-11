local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local lplr = players.LocalPlayer
local getasset = getsynasset or getcustomasset or function(location) return "rbxasset://"..location end

local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local checkpublicreponum = 0
local checkpublicrepo
checkpublicrepo = function(id)
	local suc, req = pcall(function() return requestfunc({
		Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/CustomModules/".. game.PlaceId ..".lua",
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
		return checkpublicrepo(id)
	end
	if req.StatusCode == 200 then
		return req.Body
	end
	return nil
end
local publicrepo = checkpublicrepo(game.PlaceId)
if publicrepo then
    loadstring(publicrepo)()
end



local function AnimCape(char, texture, vol)
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
        ["Function"] = function(callback)
            if callback then
				local customlink = animCapebox["Value"]:split("/")
				local successfulcustom = false
				if #customlink > 0 and animCapebox["Value"]:len() > 3 then
					if (not betterisfile("vape/assets/"..customlink[#customlink])) then 
						local suc, res = pcall(function() writefile("vape/assets/"..customlink[#customlink], game:HttpGet(animCapebox["Value"], true)) end)
						if not suc then 
							createwarning("Cape", "file failed to download : "..res, 5)
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
                            AnimCape(lplr.Character, getasset(successfulcustom and customlink[#customlink] or "vape/assets/VapeCape.webm"), animCapeVolume["Value"])
                        end)
                    end)
                end
            else
                if vapecapeconnection then
                    vapecapeconnection:Disconnect()
                end
                if lplr.Character then
                    for i,v in pairs(lplr.Character:GetDescendants()) do
                        if v.Name == "Cape" then
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
	GuiLibrary["ObjectsThatCanBeSaved"]["UtilityWindow"]["Api"].CreateOptionsButton({
		["Name"] = "Force FPS", 
		["Function"] = function(callback)
			if callback then
				lplr.CameraMode = "LockFirstPerson"
			else
				lplr.CameraMode = "Classic"
			end
		end
	}) 
end)