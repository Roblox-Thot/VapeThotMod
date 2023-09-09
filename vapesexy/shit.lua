

runFunction(function()
    GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = 'Force FPS',
        Function = function(callback)
            if callback then
                lplr.CameraMode = 'LockFirstPerson'
            else
                lplr.CameraMode = 'Classic'
            end
        end,
        HoverText = 'Locks your camera to first person and allow scrollwheel'
    })
end)

runFunction(function()
    local connectedAssHole
    local objs = game:GetObjects('rbxassetid://14217548108')
    local import = objs[1]
    import.Parent = replicatedStorageService
    import.CanCollide = false
    local index = {
        {
            name = 'wood_sword',
            offset = CFrame.Angles(math.rad(0), math.rad(-100), math.rad(-90)),
            model = import,
        }
    }
    
    GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = 'axolotl_bucket', 
        Function = function(callback)
            if callback then
                connectedAssHole = gameCamera.Viewmodel.ChildAdded:Connect(function(tool)
                    if not tool:IsA('Accessory') then return end
                    for _, v in ipairs(index) do
                        if tool.Name:match('sword') or tool.Name:match('scythe') or tool.Name:match('dagger') or tool.Name:match('hammer') then
                            for _, part in ipairs(tool:GetDescendants()) do
                                if part:IsA('BasePart') or part:IsA('MeshPart') or part:IsA('UnionOperation') then
                                    part.Transparency = 1
                                end
                            end
                            local model = v.model:Clone()
                            model.CFrame = tool:WaitForChild('Handle').CFrame * v.offset
                            model.CFrame *= CFrame.Angles(math.rad(0), math.rad(-50), math.rad(0))
                            model.Parent = tool
                            local weld = Instance.new('WeldConstraint', model)
                            weld.Part0 = model
                            weld.Part1 = tool:WaitForChild('Handle')
                            local tool2 = lplr.Character:WaitForChild(tool.Name)
                            for _, part in ipairs(tool2:GetDescendants()) do
                                if part:IsA('BasePart') or part:IsA('MeshPart') or part:IsA('UnionOperation') then
                                    part.Transparency = 1
                                end
                            end
                            local model2 = v.model:Clone()
                            model2.Anchored = false
                            model2.CFrame = tool2:WaitForChild('Handle').CFrame * v.offset
                            model2.CFrame *= CFrame.Angles(math.rad(0), math.rad(-100), math.rad(0))
                            model2.CFrame *= CFrame.new(.5, 0, -1.1) + Vector3.new(-1, 0, 0)
                            model2.Parent = tool2
                            local weld2 = Instance.new('WeldConstraint', model)
                            weld2.Part0 = model2
                            weld2.Part1 = tool2:WaitForChild('Handle')
                        end
                    end
                end)
            else
                connectedAssHole:Disconnect()
            end
        end,
        HoverText = 'Makes your swords an axolotl_bucket'
    })
end)


runFunction(function()
    GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = 'HostExploit',
        HoverText = 'Client Sided',
        Function = function(callback)
            if callback then
                lplr:SetAttribute('Cohost', true)
            else
                lplr:SetAttribute('Cohost', false)
            end
        end
    })
end)

runFunction(function()
    local OpenDaApps = {Enabled = false}
    local AppSelected = {}
    local BedwarsAppIds = require(game:GetService('StarterPlayer').StarterPlayerScripts.TS.ui.types['app-config']).BedwarsAppIds
    
    OpenDaApps = GuiLibrary.ObjectsThatCanBeSaved.UtilityWindow.Api.CreateOptionsButton({
        Name = 'AppOpener',
        HoverText = 'Allows you open any "app"',
        Function = function(cb)
            if cb then
                OpenDaApps.ToggleButton(false)
                bedwars.AppController:openApp(AppSelected.Value, {})
            end
        end
    })

    AppSelected = OpenDaApps.CreateDropdown({
        Name = 'App',
        HoverText = 'What app to open',
        Function = function() end,
        List = (function() local list = {} for _, value in pairs(BedwarsAppIds) do table.insert(list, value) end table.sort(list, function(a, b) return tostring(a) < tostring(b) end) return list end)()
    })
end)
