local GuiLibrary = shared.GuiLibrary
local players = game:GetService("Players")
local textservice = game:GetService("TextService")
local lplr = players.LocalPlayer
local workspace = game:GetService("Workspace")
local lighting = game:GetService("Lighting")
local gameCamera = workspace.CurrentCamera
local targetinfo = shared.VapeTargetInfo
local inputService = game:GetService("UserInputService")
local localmouse = lplr:GetMouse()
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local getasset = getsynasset or getcustomasset

local RenderStepTable = {}
local StepTable = {}

local function BindToRenderStep(name, num, func)
	if RenderStepTable[name] == nil then
		RenderStepTable[name] = game:GetService("RunService").RenderStepped:connect(func)
	end
end
local function UnbindFromRenderStep(name)
	if RenderStepTable[name] then
		RenderStepTable[name]:Disconnect()
		RenderStepTable[name] = nil
	end
end

local function BindToStepped(name, num, func)
	if StepTable[name] == nil then
		StepTable[name] = game:GetService("RunService").Stepped:connect(func)
	end
end
local function UnbindFromStepped(name)
	if StepTable[name] then
		StepTable[name]:Disconnect()
		StepTable[name] = nil
	end
end

local function createwarning(title, text, delay)
	pcall(function()
		local frame = GuiLibrary["CreateNotification"](title, text, delay, "assets/WarningNotification.png")
		frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
		frame.Frame.Frame.BackgroundColor3 = Color3.fromRGB(236, 129, 44)
	end)
end

local function friendCheck(plr, recolor)
	return (recolor and GuiLibrary["ObjectsThatCanBeSaved"]["Recolor visualsToggle"]["Api"]["Enabled"] or (not recolor)) and GuiLibrary["ObjectsThatCanBeSaved"]["Use FriendsToggle"]["Api"]["Enabled"] and table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name) and GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectListEnabled"][table.find(GuiLibrary["ObjectsThatCanBeSaved"]["FriendsListTextCircleList"]["Api"]["ObjectList"], plr.Name)]
end

local function getPlayerColor(plr)
	return (friendCheck(plr, true) and Color3.fromHSV(GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Hue"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Sat"], GuiLibrary["ObjectsThatCanBeSaved"]["Friends ColorSliderColor"]["Api"]["Value"]) or tostring(plr.TeamColor) ~= "White" and plr.TeamColor.Color)
end

local function getcustomassetfunc(path)
	if not isfile(path) then
		spawn(function()
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.SourceSans
			textlabel.TextColor3 = Color3.new(1, 1, 1)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = GuiLibrary["MainGui"]
			repeat wait() until isfile(path)
			textlabel:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/7GrandDadPGN/VapeV4ForRoblox/main/"..path:gsub("vape/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

shared.vapeteamcheck = function(plr)
	return (GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] and (plr.Team ~= lplr.Team or (lplr.Team == nil or #lplr.Team:GetPlayers() == #game:GetService("Players"):GetChildren())) or GuiLibrary["ObjectsThatCanBeSaved"]["Teams by colorToggle"]["Api"]["Enabled"] == false)
end

-- local function targetCheck(plr, check)
-- 	return (check and plr.Character.Humanoid.Health > 0 and plr.Character:FindFirstChild("ForceField") == nil or check == false)
-- end

local function isPlayerTargetable(plr, target, friend)
    return plr ~= lplr and plr and (friend and friendCheck(plr) == nil or (not friend)) and targetCheck(plr, target) and shared.vapeteamcheck(plr)
end

local function vischeck(char, part)
	return not unpack(cam:GetPartsObscuringTarget({lplr.Character[part].Position, char[part].Position}, {lplr.Character, char}))
end

local function runcode(func)
	func()
end

local function CalculateObjectPosition(pos)
	local newpos = cam:WorldToViewportPoint(cam.CFrame:pointToWorldSpace(cam.CFrame:pointToObjectSpace(pos)))
	return Vector2.new(newpos.X, newpos.Y)
end

local function CalculateLine(startVector, endVector, obj)
	local Distance = (startVector - endVector).Magnitude
	obj.Size = UDim2.new(0, Distance, 0, 2)
	obj.Position = UDim2.new(0, (startVector.X + endVector.X) / 2, 0, ((startVector.Y + endVector.Y) / 2) - 36)
	obj.Rotation = math.atan2(endVector.Y - startVector.Y, endVector.X - startVector.X) * (180 / math.pi)
end

local function findTouchInterest(tool)
	for i,v in pairs(tool:GetDescendants()) do
		if v:IsA("TouchTransmitter") then
			return v
		end
	end
	return nil
end

function isAlive()
	local a, b = pcall(function() return getRoot().Name end)
	return a
end

function getRoot()
    for i,v in next,workspace:GetChildren() do
        if v:IsA("Model") and v.Name=="soldier_model" and v:FindFirstChild("fpv_humanoid") then
            return v.HumanoidRootPart
        end
    end
end

local RunLoops = {RenderStepTable = {}, StepTable = {}, HeartTable = {}}
do
	function RunLoops:BindToRenderStep(name, func)
		if RunLoops.RenderStepTable[name] == nil then
			RunLoops.RenderStepTable[name] = game:GetService("RunService").RenderStepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromRenderStep(name)
		if RunLoops.RenderStepTable[name] then
			RunLoops.RenderStepTable[name]:Disconnect()
			RunLoops.RenderStepTable[name] = nil
		end
	end

	function RunLoops:BindToStepped(name, func)
		if RunLoops.StepTable[name] == nil then
			RunLoops.StepTable[name] = game:GetService("RunService").Stepped:Connect(func)
		end
	end

	function RunLoops:UnbindFromStepped(name)
		if RunLoops.StepTable[name] then
			RunLoops.StepTable[name]:Disconnect()
			RunLoops.StepTable[name] = nil
		end
	end

	function RunLoops:BindToHeartbeat(name, func)
		if RunLoops.HeartTable[name] == nil then
			RunLoops.HeartTable[name] = game:GetService("RunService").Heartbeat:Connect(func)
		end
	end

	function RunLoops:UnbindFromHeartbeat(name)
		if RunLoops.HeartTable[name] then
			RunLoops.HeartTable[name]:Disconnect()
			RunLoops.HeartTable[name] = nil
		end
	end
end

GuiLibrary.RemoveObject("FlyOptionsButton")
GuiLibrary.RemoveObject("PhaseOptionsButton")
GuiLibrary.RemoveObject("ESPOptionsButton")
GuiLibrary.RemoveObject("SpiderOptionsButton")
GuiLibrary.RemoveObject("ChatSpammerOptionsButton")
GuiLibrary.RemoveObject("AntiVoidOptionsButton")
GuiLibrary.RemoveObject("FreecamOptionsButton")
GuiLibrary.RemoveObject("SafeWalkOptionsButton")
GuiLibrary.RemoveObject("CapeOptionsButton")
GuiLibrary.RemoveObject("ArrowsOptionsButton")
GuiLibrary.RemoveObject("DisguiseOptionsButton")
GuiLibrary.RemoveObject("FOVChangerOptionsButton")
GuiLibrary.RemoveObject("HealthOptionsButton")
GuiLibrary.RemoveObject("NameTagsOptionsButton")
GuiLibrary.RemoveObject("SearchOptionsButton")
GuiLibrary.RemoveObject("TracersOptionsButton")
GuiLibrary.RemoveObject("KillauraOptionsButton")
GuiLibrary.RemoveObject("MouseTPOptionsButton")
GuiLibrary.RemoveObject("SpeedOptionsButton")
GuiLibrary.RemoveObject("SpinBotOptionsButton")
GuiLibrary.RemoveObject("SwimOptionsButton")
GuiLibrary.RemoveObject("TriggerBotOptionsButton")
GuiLibrary.RemoveObject("SilentAimOptionsButton")
GuiLibrary.RemoveObject("ReachOptionsButton")
GuiLibrary.RemoveObject("AnimationPlayerOptionsButton")
GuiLibrary.RemoveObject("AutoReportOptionsButton")
GuiLibrary.RemoveObject("ChamsOptionsButton")
GuiLibrary.RemoveObject("BreadcrumbsOptionsButton")
GuiLibrary.RemoveObject("BlinkOptionsButton")
GuiLibrary.RemoveObject("HighJumpOptionsButton")
GuiLibrary.RemoveObject("HitBoxesOptionsButton")
GuiLibrary.RemoveObject("LongJumpOptionsButton")

runcode(function()
	local Fly = {Enabled = false}
	local FlySpeed = {Value = 1}
	local FlyVerticalSpeed = {Value = 1}
	local FlyTPOff = {Value = 10}
	local FlyTPOn = {Value = 10}
	local FlyCFrameVelocity = {Enabled = false}
	local FlyWallCheck = {Enabled = false}
	local FlyVertical = {Enabled = false}
	local FlyMethod = {Value = "Normal"}
	local FlyMoveMethod = {Value = "MoveDirection"}
	local FlyKeys = {Value = "Space/LeftControl"}
	local FlyState = {Value = "Normal"}
	local FlyPlatformToggle = {Enabled = false}
	local FlyPlatformStanding = {Enabled = false}
	local FlyRaycast = RaycastParams.new()
	FlyRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	FlyRaycast.RespectCanCollide = true
	local FlyJumpCFrame = CFrame.new(0, 0, 0)
	local FlyConnectionStart
	local FlyConnectionEnd
	local FlyAliveCheck = false
	local FlyUp = false
	local FlyDown = false
	local FlyY = 0
	local FlyPlatform
	local w = 0
	local s = 0
	local a = 0
	local d = 0
	local alternatelist = {"Normal"}
	Fly = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Fly", 
		Function = function(callback)
			if callback then
				local FlyPlatformTick = tick() + 0.2
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				FlyConnectionStart = inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() ~= nil then return end
					if input1.KeyCode == Enum.KeyCode.W then
						w = -1
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 1
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = -1
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 1
					end
					if FlyVertical.Enabled then
						local divided = FlyKeys.Value:split("/")
						if input1.KeyCode == Enum.KeyCode[divided[1]] then
							FlyUp = true
						elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
							FlyDown = true
						end
					end
				end)
				FlyConnectionEnd = inputService.InputEnded:Connect(function(input1)
					local divided = FlyKeys.Value:split("/")
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					elseif input1.KeyCode == Enum.KeyCode.S then
						s = 0
					elseif input1.KeyCode == Enum.KeyCode.A then
						a = 0
					elseif input1.KeyCode == Enum.KeyCode.D then
						d = 0
					elseif input1.KeyCode == Enum.KeyCode[divided[1]] then
						FlyUp = false
					elseif input1.KeyCode == Enum.KeyCode[divided[2]] then
						FlyDown = false
					end
				end)
				if isAlive() and FlyMethod.Value == "Jump" then
					getRoot().Parent.fpv_humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
				end
				local FlyTP = false
				local FlyTPTick = tick()
				local FlyTPY
				RunLoops:BindToHeartbeat("Fly", function(delta) 
					if isAlive() and (typeof(getRoot()) ~= "Instance" or isnetworkowner(getRoot())) then
						getRoot().Parent.fpv_humanoid.PlatformStand = FlyPlatformStanding.Enabled
						if not FlyY then FlyY = getRoot().CFrame.p.Y end
						local movevec = (FlyMoveMethod.Value == "Manual" and (CFrame.lookAt(gameCamera.CFrame.p, gameCamera.CFrame.p + Vector3.new(gameCamera.CFrame.lookVector.X, 0, gameCamera.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or getRoot().Parent.fpv_humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.zero
						if FlyState.Value ~= "None" then 
							getRoot().Parent.fpv_humanoid:ChangeState(Enum.HumanoidStateType[FlyState.Value])
						end
						if FlyMethod.Value == "Normal" or FlyMethod.Value == "Bounce" then
							if FlyPlatformStanding.Enabled then
								getRoot().CFrame = CFrame.new(getRoot().CFrame.p, getRoot().CFrame.p + gameCamera.CFrame.lookVector)
								getRoot().RotVelocity = Vector3.zero
							end
							getRoot().Velocity = (movevec * FlySpeed.Value) + Vector3.new(0, 0.85 + (FlyMethod.Value == "Bounce" and (tick() % 0.5 > 0.25 and -10 or 10) or 0) + (FlyUp and FlyVerticalSpeed.Value or 0) + (FlyDown and -FlyVerticalSpeed.Value or 0), 0)
						end
						if FlyPlatform then
							FlyPlatform.CFrame = (FlyMethod.Value == "Jump" and FlyJumpCFrame or getRoot().CFrame * CFrame.new(0, -(getRoot().Parent.fpv_humanoid.HipHeight + (getRoot().Size.Y / 2) + 0.53), 0))
							FlyPlatform.Parent = gameCamera
							if FlyUp or FlyPlatformTick >= tick() then 
								getRoot().Parent.fpv_humanoid:ChangeState(Enum.HumanoidStateType.Landed)
							end
						end
					else
						FlyY = nil
					end
				end)
			else
				FlyUp = false
				FlyDown = false
				FlyY = nil
				FlyConnectionStart:Disconnect()
				FlyConnectionEnd:Disconnect()
				RunLoops:UnbindFromHeartbeat("Fly")
				if isAlive() and FlyPlatformStanding.Enabled then
					getRoot().Parent.fpv_humanoid.PlatformStand = false
				end
				if FlyPlatform then
					FlyPlatform.Parent = nil
					getRoot().Parent.fpv_humanoid:ChangeState(Enum.HumanoidStateType.Landed)
				end
			end
		end
	})
	FlyMethod = Fly.CreateDropdown({
		Name = "Mode", 
		List = {"Normal", "Bounce"},
		Function = function(val)
			FlyY = nil
		end
	})
	FlyMoveMethod = Fly.CreateDropdown({
		Name = "Movement", 
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	FlyKeys = Fly.CreateDropdown({
		Name = "Keys", 
		List = {"Space/LeftControl", "Space/LeftShift", "E/Q", "Space/Q"},
		Function = function(val) end
	})
	local states = {"None"}
	for i,v in pairs(Enum.HumanoidStateType:GetEnumItems()) do if v.Name ~= "Dead" and v.Name ~= "None" then table.insert(states, v.Name) end end
	FlyState = Fly.CreateDropdown({
		Name = "State", 
		List = states,
		Function = function(val) end
	})
	FlySpeed = Fly.CreateSlider({
		Name = "Speed",
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	FlyVerticalSpeed = Fly.CreateSlider({
		Name = "Vertical Speed",
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	FlyTPOn = Fly.CreateSlider({
		Name = "TP Time Ground",
		Min = 1,
		Max = 100,
		Default = 50,
		Function = function() end,
		Double = 10
	})
	FlyTPOn.Object.Visible = false
	FlyTPOff = Fly.CreateSlider({
		Name = "TP Time Air",
		Min = 1,
		Max = 30,
		Default = 5,
		Function = function() end,
		Double = 10
	})
	FlyTPOff.Object.Visible = false
	FlyPlatformToggle = Fly.CreateToggle({
		Name = "FloorPlatform", 
		Function = function(callback)
			if callback then
				FlyPlatform = Instance.new("Part")
				FlyPlatform.Anchored = true
				FlyPlatform.CanCollide = true
				FlyPlatform.Size = Vector3.new(2, 1, 2)
				FlyPlatform.Transparency = 0
			else
				if FlyPlatform then 
					FlyPlatform:Destroy()
					FlyPlatform = nil 
				end
			end
		end
	})
	FlyPlatformStanding = Fly.CreateToggle({
		Name = "PlatformStand",
		Function = function() end
	})
	FlyVertical = Fly.CreateToggle({
		Name = "Y Level", 
		Function = function() end
	})
	FlyWallCheck = Fly.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
	FlyWallCheck.Object.Visible = false
	FlyCFrameVelocity = Fly.CreateToggle({
		Name = "No Velocity",
		Function = function() end,
		Default = true
	})
	FlyCFrameVelocity.Object.Visible = false
end)

runcode(function()
	local Phase = {Enabled = false}
	Phase = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Phase", 
		Function = function(callback)
			if callback then
				RunLoops:BindToStepped("Phase", function() -- has to be ran on stepped idk why
					if isAlive() then
						getRoot().CanCollide = false
					end
				end)
			else
				RunLoops:UnbindFromStepped("Phase")
				task.wait()
				
				getRoot().CanCollide = true
			end
		end,
		HoverText = "Lets you Phase/Clip through walls. (Hold shift to use Phase over spider)"
	})
end)


runcode(function()
	local Speed = {Enabled = false}
	local SpeedValue = {Value = 1}
	local SpeedMethod = {Value = "AntiCheat A"}
	local SpeedMoveMethod = {Value = "MoveDirection"}
	local SpeedDelay = {Value = 0.7}
	local SpeedPulseDuration = {Value = 100}
	local SpeedWallCheck = {Enabled = true}
	local SpeedJump = {Enabled = false}
	local SpeedJumpHeight = {Value = 20}
	local SpeedJumpVanilla = {Enabled = false}
	local SpeedJumpAlways = {Enabled = false}
	local SpeedDelayTick = tick()
	local SpeedRaycast = RaycastParams.new()
	SpeedRaycast.FilterType = Enum.RaycastFilterType.Blacklist
	SpeedRaycast.RespectCanCollide = true
	local SpeedDown
	local SpeedUp
	local w = 0
	local s = 0
	local a = 0
	local d = 0

	local alternatelist = {"Normal", "AntiCheat A", "AntiCheat B", "AntiCheat C", "AntiCheat D"}
	Speed = GuiLibrary.ObjectsThatCanBeSaved.BlatantWindow.Api.CreateOptionsButton({
		Name = "Speed", 
		Function = function(callback)
			if callback then
				w = inputService:IsKeyDown(Enum.KeyCode.W) and -1 or 0
				s = inputService:IsKeyDown(Enum.KeyCode.S) and 1 or 0
				a = inputService:IsKeyDown(Enum.KeyCode.A) and -1 or 0
				d = inputService:IsKeyDown(Enum.KeyCode.D) and 1 or 0
				SpeedDown = inputService.InputBegan:Connect(function(input1)
					if inputService:GetFocusedTextBox() == nil then
						if input1.KeyCode == Enum.KeyCode.W then
							w = -1
						end
						if input1.KeyCode == Enum.KeyCode.S then
							s = 1
						end
						if input1.KeyCode == Enum.KeyCode.A then
							a = -1
						end
						if input1.KeyCode == Enum.KeyCode.D then
							d = 1
						end
					end
				end)
				SpeedUp = inputService.InputEnded:Connect(function(input1)
					if input1.KeyCode == Enum.KeyCode.W then
						w = 0
					end
					if input1.KeyCode == Enum.KeyCode.S then
						s = 0
					end
					if input1.KeyCode == Enum.KeyCode.A then
						a = 0
					end
					if input1.KeyCode == Enum.KeyCode.D then
						d = 0
					end
				end)
				local pulsetick = tick()
				task.spawn(function()
					repeat
						pulsetick = tick() + (SpeedPulseDuration.Value / 100)
						task.wait((SpeedDelay.Value / 10) + (SpeedPulseDuration.Value / 100))
					until (not Speed.Enabled)
				end)
				RunLoops:BindToHeartbeat("Speed", function(delta)
					root = getRoot()
					if isAlive() and (typeof(root) ~= "Instance" or isnetworkowner(root)) then
						local movevec = (SpeedMoveMethod.Value == "Manual" and (CFrame.lookAt(gameCamera.CFrame.p, gameCamera.CFrame.p + Vector3.new(gameCamera.CFrame.lookVector.X, 0, gameCamera.CFrame.lookVector.Z))):VectorToWorldSpace(Vector3.new(a + d, 0, w + s)) or getRoot().Parent.fpv_humanoid.MoveDirection).Unit
						movevec = movevec == movevec and Vector3.new(movevec.X, 0, movevec.Z) or Vector3.new()
						SpeedRaycast.FilterDescendantsInstances = {lplr.Character, cam}
						if SpeedMethod.Value == "Velocity" then
							local newvelo = movevec * SpeedValue.Value
							root.Velocity = Vector3.new(newvelo.X, root.Velocity.Y, newvelo.Z)
						elseif SpeedMethod.Value == "CFrame" then
							local newpos = (movevec * (math.max(SpeedValue.Value - getRoot().Parent.fpv_humanoid.WalkSpeed, 0) * delta))
							if SpeedWallCheck.Enabled then
								local ray = workspace:Raycast(root.Position, newpos, SpeedRaycast)
								if ray then newpos = (ray.Position - root.Position) end
							end
							root.CFrame = root.CFrame + newpos
						elseif SpeedMethod.Value == "TP" then
							if SpeedDelayTick <= tick() then
								SpeedDelayTick = tick() + (SpeedDelay.Value / 10)
								local newpos = (movevec * SpeedValue.Value)
								if SpeedWallCheck.Enabled then
									local ray = workspace:Raycast(root.Position, newpos, SpeedRaycast)
									if ray then newpos = (ray.Position - root.Position) end
								end
								root.CFrame = root.CFrame + newpos
							end
						elseif SpeedMethod.Value == "Pulse" then 
							local pulsenum = (SpeedPulseDuration.Value / 100)
							local newvelo = movevec * (SpeedValue.Value + (getRoot().Parent.fpv_humanoid.WalkSpeed - SpeedValue.Value) * (1 - (math.max(pulsetick - tick(), 0)) / pulsenum))
							root.Velocity = Vector3.new(newvelo.X, root.Velocity.Y, newvelo.Z)
						end
						if SpeedJump.Enabled and (SpeedJumpAlways.Enabled or KillauraNearTarget) then
							if (getRoot().Parent.fpv_humanoid.FloorMaterial ~= Enum.Material.Air) and getRoot().Parent.fpv_humanoid.MoveDirection ~= Vector3.new() then
								if SpeedJumpVanilla.Enabled then 
									getRoot().Parent.fpv_humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
								else
									root.Velocity = Vector3.new(root.Velocity.X, SpeedJumpHeight.Value, root.Velocity.Z)
								end
							end
						end
					end
				end)
			else
				SpeedDelayTick = 0
				if SpeedUp then SpeedUp:Disconnect() end
				if SpeedDown then SpeedDown:Disconnect() end
				RunLoops:UnbindFromHeartbeat("Speed")
			end
		end,
		HoverText = "Velocity and CFrame work fine use them",
		ExtraText = function() 
			if GuiLibrary.ObjectsThatCanBeSaved["Text GUIAlternate TextToggle"].Api.Enabled then 
				return alternatelist[table.find(SpeedMethod.List, SpeedMethod.Value)]
			end
			return SpeedMethod.Value
		end
	})
	SpeedMethod = Speed.CreateDropdown({
		Name = "Mode", 
		List = {"Velocity", "CFrame", "TP", "Pulse"},
		Function = function(val)
			SpeedDelay.Object.Visible = val == "TP" or val == "Pulse"
			SpeedWallCheck.Object.Visible = val == "CFrame" or val == "TP"
			SpeedPulseDuration.Object.Visible = val == "Pulse"
		end
	})
	SpeedMoveMethod = Speed.CreateDropdown({
		Name = "Movement", 
		List = {"Manual", "MoveDirection"},
		Function = function(val) end
	})
	SpeedValue = Speed.CreateSlider({
		Name = "Speed", 
		Min = 1,
		Max = 150, 
		Function = function(val) end
	})
	SpeedDelay = Speed.CreateSlider({
		Name = "Delay", 
		Min = 1,
		Max = 50, 
		Function = function(val)
			SpeedDelayTick = tick() + (val / 10)
		end,
		Default = 7,
		Double = 10
	})
	SpeedPulseDuration = Speed.CreateSlider({
		Name = "Pulse Duration",
		Min = 1,
		Max = 100,
		Function = function() end,
		Default = 50,
		Double = 100
	})
	SpeedJump = Speed.CreateToggle({
		Name = "AutoJump", 
		Function = function(callback) 
			if SpeedJumpHeight.Object then SpeedJumpHeight.Object.Visible = callback end
			if SpeedJumpAlways.Object then
				SpeedJump.Object.ToggleArrow.Visible = callback
				SpeedJumpAlways.Object.Visible = callback
			end
			if SpeedJumpVanilla.Object then SpeedJumpVanilla.Object.Visible = callback end
		end,
		Default = true
	})
	SpeedJumpHeight = Speed.CreateSlider({
		Name = "Jump Height",
		Min = 0,
		Max = 30,
		Default = 25,
		Function = function() end
	})
	SpeedJumpAlways = Speed.CreateToggle({
		Name = "Always Jump",
		Function = function() end
	})
	SpeedJumpVanilla = Speed.CreateToggle({
		Name = "Real Jump",
		Function = function() end
	})
	SpeedWallCheck = Speed.CreateToggle({
		Name = "Wall Check",
		Function = function() end,
		Default = true
	})
end)

runcode(function()
	local playersFolder = Instance.new("Folder",game:GetService("CoreGui"))--I refuse to protect the folder
	local ESPconnection
	local ESP = {["Enabled"] = false}
	local ESPColor = {Value = 0.44}
	ESP = GuiLibrary.ObjectsThatCanBeSaved.RenderWindow.Api.CreateOptionsButton({
		["Name"] = "ESP",
		["Function"] = function(cb)
			if cb then
				local function esp(player)
					if player and not player:FindFirstChild("friendly_marker") and not player:FindFirstChild("fpv_humanoid") then
						local playerEsp = Instance.new("Highlight",playersFolder)
						playerEsp.Adornee = player
						playerEsp.FillColor = Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
						playerEsp.OutlineColor = Color3.fromHSV(ESPOutlineColor.Hue, ESPOutlineColor.Sat, ESPOutlineColor.Value)
						player.AncestryChanged:Connect(function()
							playerEsp:Destroy()
						end)
					end
				end
				for i,v in next,workspace:GetChildren() do
					if v:IsA("Model") and v.Name=="soldier_model" then
						esp(v)
					end
				end
				ESPconnection = workspace.ChildAdded:Connect(function(child)
					task.wait()
					if child:IsA("Model") and child.Name=="soldier_model" then
						esp(child)
					end
				end)
			else
				ESPconnection:Disconnect()
				playersFolder:ClearAllChildren()
			end
		end
	})
	
	ESPColor = ESP.CreateColorSlider({
		Name = "Player Color",
		Function = function(val) 
			for i,v in pairs(playersFolder:GetChildren()) do 
				v.FillColor = Color3.fromHSV(ESPColor.Hue, ESPColor.Sat, ESPColor.Value)
			end
		end
	})
	
	ESPOutlineColor = ESP.CreateColorSlider({
		Name = "Outline Player Color",
		Function = function(val) 
			for i,v in pairs(playersFolder:GetChildren()) do 
				v.OutlineColor = Color3.fromHSV(ESPOutlineColor.Hue, ESPOutlineColor.Sat, ESPOutlineColor.Value)
			end
		end
	})
end)
