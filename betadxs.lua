local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
if not Rayfield then return end

local isMobile = UserInputService.TouchEnabled and not UserInputService.MouseEnabled
local uiScale = isMobile and 1.5 or 1

local Window = Rayfield:CreateWindow({
    Name = "doxxswag Hub",
    LoadingTitle = "doxxswag Hub",
    LoadingSubtitle = "by doxxswag",
    ConfigurationSaving = {Enabled = true, FolderName = "doxxswagHub", FileName = "doxxswagConfig"},
    Discord = {Enabled = true, Invite = "your_discord_invite", RememberJoins = true},
    KeySystem = false
})

Window:CreateTab("Main", 4483362458)
local OtherHubsTab = Window:CreateTab("Other Hubs", 4483362458)

local MainTab = Window:GetTab("Main")
MainTab:CreateSection("Player Modifications")

local flying = false
local flySpeed = 50
MainTab:CreateToggle({
    Name = "Fly",
    CurrentValue = false,
    Flag = "Fly",
    Callback = function(Value)
        flying = Value
        if flying then
            local gui = Rayfield:CreateWindow({
                Name = "Fly Settings",
                LoadingTitle = "Fly Control",
                LoadingSubtitle = "Adjust your flight"
            })
            gui:CreateSlider({
                Name = "Fly Speed",
                Range = {1, 100},
                Increment = 1,
                CurrentValue = 50,
                Flag = "FlySpeed",
                Callback = function(Value) flySpeed = Value end
            })
            gui:CreateButton({
                Name = "Disable Fly",
                Callback = function()
                    flying = false
                    gui:Destroy()
                end
            })
            spawn(function()
                while flying do
                    local character = LocalPlayer.Character
                    if character and character:FindFirstChild("HumanoidRootPart") then
                        local hrp = character.HumanoidRootPart
                        local humanoid = character:FindFirstChildOfClass("Humanoid")
                        if humanoid then humanoid.PlatformStand = true end
                        local velocity = Vector3.new()
                        if UserInputService:IsKeyDown(Enum.KeyCode.W) then velocity = velocity + Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.S) then velocity = velocity - Camera.CFrame.LookVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.A) then velocity = velocity - Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.D) then velocity = velocity + Camera.CFrame.RightVector end
                        if UserInputService:IsKeyDown(Enum.KeyCode.Space) then velocity = velocity + Vector3.new(0, 1, 0) end
                        if UserInputService:IsKeyDown(Enum.KeyCode.LeftControl) then velocity = velocity - Vector3.new(0, 1, 0) end
                        hrp.Velocity = velocity * flySpeed
                    end
                    RunService.Heartbeat:Wait()
                end
                local character = LocalPlayer.Character
                if character then
                    local humanoid = character:FindFirstChildOfClass("Humanoid")
                    if humanoid then humanoid.PlatformStand = false end
                end
            end)
        end
    end
})

local flingSpeed = 100
MainTab:CreateButton({
    Name = "Fling All Players",
    Callback = function()
        local gui = Rayfield:CreateWindow({
            Name = "Fling Settings",
            LoadingTitle = "Fling Control",
            LoadingSubtitle = "Adjust fling power"
        })
        gui:CreateSlider({
            Name = "Fling Speed",
            Range = {50, 500},
            Increment = 10,
            CurrentValue = 100,
            Flag = "FlingSpeed",
            Callback = function(Value) flingSpeed = Value end
        })
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                local root = player.Character.HumanoidRootPart
                local bodyVelocity = Instance.new("BodyVelocity")
                bodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                bodyVelocity.Velocity = Vector3.new(math.random(-1, 1), 1, math.random(-1, 1)) * flingSpeed
                bodyVelocity.Parent = root
                game:GetService("Debris"):AddItem(bodyVelocity, 0.5)
            end
        end
        Rayfield:Notify({Title = "Fling", Content = "Flung all players!", Duration = 3, Image = 4483362458})
    end
})

MainTab:CreateSlider({
    Name = "WalkSpeed",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Speed",
    CurrentValue = 16,
    Flag = "WalkSpeed",
    Callback = function(Value) getgenv().WalkSpeedValue = Value end
})

MainTab:CreateToggle({
    Name = "Enable WalkSpeed",
    CurrentValue = false,
    Flag = "EnableWalkSpeed",
    Callback = function(Value)
        if Value then
            getgenv().WalkSpeedConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.WalkSpeed = getgenv().WalkSpeedValue or 16
                end
            end)
        else
            if getgenv().WalkSpeedConnection then
                getgenv().WalkSpeedConnection:Disconnect()
                getgenv().WalkSpeedConnection = nil
            end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.WalkSpeed = 16
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "JumpPower",
    Range = {0, 250},
    Increment = 1,
    Suffix = "Power",
    CurrentValue = 50,
    Flag = "JumpPower",
    Callback = function(Value) getgenv().JumpPowerValue = Value end
})

MainTab:CreateToggle({
    Name = "Enable JumpPower",
    CurrentValue = false,
    Flag = "EnableJumpPower",
    Callback = function(Value)
        if Value then
            getgenv().JumpPowerConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.JumpPower = getgenv().JumpPowerValue or 50
                    character.Humanoid.UseJumpPower = true
                end
            end)
        else
            if getgenv().JumpPowerConnection then
                getgenv().JumpPowerConnection:Disconnect()
                getgenv().JumpPowerConnection = nil
            end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.JumpPower = 50
                character.Humanoid.UseJumpPower = true
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Infinite Jump",
    CurrentValue = false,
    Flag = "InfiniteJump",
    Callback = function(Value)
        if Value then
            getgenv().InfiniteJumpConnection = UserInputService.JumpRequest:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
                end
            end)
        else
            if getgenv().InfiniteJumpConnection then
                getgenv().InfiniteJumpConnection:Disconnect()
                getgenv().InfiniteJumpConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Godmode",
    CurrentValue = false,
    Flag = "Godmode",
    Callback = function(Value)
        if Value then
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.MaxHealth = math.huge
                character.Humanoid.Health = math.huge
            end
            getgenv().GodmodeConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid")
                char.Humanoid.MaxHealth = math.huge
                char.Humanoid.Health = math.huge
            end)
        else
            if getgenv().GodmodeConnection then
                getgenv().GodmodeConnection:Disconnect()
                getgenv().GodmodeConnection = nil
            end
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.MaxHealth = 100
                character.Humanoid.Health = 100
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Noclip",
    CurrentValue = false,
    Flag = "Noclip",
    Callback = function(Value)
        if Value then
            getgenv().NoclipConnection = RunService.Stepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = false end
                    end
                end
            end)
        else
            if getgenv().NoclipConnection then
                getgenv().NoclipConnection:Disconnect()
                getgenv().NoclipConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.CanCollide = true end
                end
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Invisibility",
    CurrentValue = false,
    Flag = "Invisibility",
    Callback = function(Value)
        if Value then
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.NameDisplayDistance = 0 end
            end
            getgenv().InvisibilityConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid")
                for _, part in pairs(char:GetDescendants()) do
                    if part:IsA("BasePart") or part:IsA("Decal") then part.Transparency = 1 end
                end
                char.Humanoid.NameDisplayDistance = 0
            end)
        else
            if getgenv().InvisibilityConnection then
                getgenv().InvisibilityConnection:Disconnect()
                getgenv().InvisibilityConnection = nil
            end
            local character = LocalPlayer.Character
            if character then
                for _, part in pairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then part.Transparency = 0
                    elseif part:IsA("Decal") then part.Transparency = part:GetAttribute("OriginalTransparency") or 0 end
                end
                local humanoid = character:FindFirstChildOfClass("Humanoid")
                if humanoid then humanoid.NameDisplayDistance = 100 end
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Rainbow Character",
    CurrentValue = false,
    Flag = "RainbowCharacter",
    Callback = function(Value)
        if Value then
            getgenv().RainbowConnection = RunService.RenderStepped:Connect(function()
                local character = LocalPlayer.Character
                if character then
                    for _, part in pairs(character:GetChildren()) do
                        if part:IsA("BasePart") then
                            part.BrickColor = BrickColor.new(Color3.fromHSV(tick() % 5 / 5, 1, 1))
                        end
                    end
                end
            end)
        else
            if getgenv().RainbowConnection then
                getgenv().RainbowConnection:Disconnect()
                getgenv().RainbowConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Click Teleport",
    CurrentValue = false,
    Flag = "ClickTP",
    Callback = function(Value)
        if Value then
            local mouse = LocalPlayer:GetMouse()
            getgenv().ClickTPConnection = mouse.Button1Down:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = CFrame.new(mouse.Hit.Position + Vector3.new(0, 3, 0))
                end
            end)
        else
            if getgenv().ClickTPConnection then
                getgenv().ClickTPConnection:Disconnect()
                getgenv().ClickTPConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Kill Aura",
    CurrentValue = false,
    Flag = "KillAura",
    Callback = function(Value)
        if Value then
            getgenv().KillAuraConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    for _, player in pairs(Players:GetPlayers()) do
                        if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Humanoid") and player.Character:FindFirstChild("HumanoidRootPart") then
                            if (player.Character.HumanoidRootPart.Position - character.HumanoidRootPart.Position).Magnitude <= 10 then
                                player.Character.Humanoid.Health = 0
                            end
                        end
                    end
                end
            end)
        else
            if getgenv().KillAuraConnection then
                getgenv().KillAuraConnection:Disconnect()
                getgenv().KillAuraConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Clicker",
    CurrentValue = false,
    Flag = "AutoClicker",
    Callback = function(Value)
        if Value then
            getgenv().AutoClickerConnection = RunService.Heartbeat:Connect(function()
                LocalPlayer:GetMouse():click()
            end)
        else
            if getgenv().AutoClickerConnection then
                getgenv().AutoClickerConnection:Disconnect()
                getgenv().AutoClickerConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "No Fall Damage",
    CurrentValue = false,
    Flag = "NoFallDamage",
    Callback = function(Value)
        if Value then
            getgenv().NoFallDamageConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid")
                char.Humanoid.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
                        char.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end)
            local character = LocalPlayer.Character
            if character and character:FindFirstChildOfClass("Humanoid") then
                character.Humanoid.StateChanged:Connect(function(old, new)
                    if new == Enum.HumanoidStateType.FallingDown or new == Enum.HumanoidStateType.Ragdoll then
                        character.Humanoid:ChangeState(Enum.HumanoidStateType.Running)
                    end
                end)
            end
        else
            if getgenv().NoFallDamageConnection then
                getgenv().NoFallDamageConnection:Disconnect()
                getgenv().NoFallDamageConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "X-Ray",
    CurrentValue = false,
    Flag = "XRay",
    Callback = function(Value)
        if Value then
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part.Transparency < 0.9 then
                    part:SetAttribute("OriginalTransparency", part.Transparency)
                    part.Transparency = 0.9
                end
            end
        else
            for _, part in pairs(workspace:GetDescendants()) do
                if part:IsA("BasePart") and part:GetAttribute("OriginalTransparency") then
                    part.Transparency = part:GetAttribute("OriginalTransparency")
                    part:SetAttribute("OriginalTransparency", nil)
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Respawn",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character:FindFirstChildOfClass("Humanoid") then
            character.Humanoid.Health = 0
        end
        Rayfield:Notify({Title = "Respawn", Content = "Character respawned!", Duration = 3, Image = 4483362458})
    end
})

MainTab:CreateToggle({
    Name = "Anti-AFK",
    CurrentValue = false,
    Flag = "AntiAFK",
    Callback = function(Value)
        if Value then
            getgenv().AntiAFKConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChild("HumanoidRootPart") then
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame + Vector3.new(0.01, 0, 0)
                    wait(0.1)
                    character.HumanoidRootPart.CFrame = character.HumanoidRootPart.CFrame - Vector3.new(0.01, 0, 0)
                end
            end)
        else
            if getgenv().AntiAFKConnection then
                getgenv().AntiAFKConnection:Disconnect()
                getgenv().AntiAFKConnection = nil
            end
        end
    end
})

MainTab:CreateSection("Teleportation")
MainTab:CreateDropdown({
    Name = "Teleport to Player",
    Options = (function()
        local players = {}
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                table.insert(players, player.Name)
            end
        end
        return players
    end)(),
    CurrentOption = "",
    Flag = "TeleportPlayer",
    Callback = function(Option)
        local targetPlayer = Players:FindFirstChild(Option)
        if targetPlayer and targetPlayer.Character and targetPlayer.Character:FindFirstChild("HumanoidRootPart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = targetPlayer.Character.HumanoidRootPart.CFrame
        end
    end
})

MainTab:CreateInput({
    Name = "Teleport to Coordinates",
    PlaceholderText = "X,Y,Z",
    CurrentValue = "",
    Flag = "TeleportCoords",
    Callback = function(Value)
        local coords = {}
        for coord in string.gmatch(Value, "[^,]+") do
            table.insert(coords, tonumber(coord))
        end
        if #coords == 3 then
            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(Vector3.new(coords[1], coords[2], coords[3]))
        end
    end
})

MainTab:CreateSection("Environment Modifications")
MainTab:CreateSlider({
    Name = "Gravity",
    Range = {0, 500},
    Increment = 1,
    Suffix = "Gravity",
    CurrentValue = 196.2,
    Flag = "Gravity",
    Callback = function(Value)
        workspace.Gravity = Value
    end
})

MainTab:CreateSlider({
    Name = "Field of View",
    Range = {30, 120},
    Increment = 1,
    Suffix = "FOV",
    CurrentValue = 70,
    Flag = "FOV",
    Callback = function(Value)
        Camera.FieldOfView = Value
    end
})

MainTab:CreateButton({
    Name = "Day Time",
    Callback = function()
        game:GetService("Lighting").ClockTime = 12
    end
})

MainTab:CreateButton({
    Name = "Night Time",
    Callback = function()
        game:GetService("Lighting").ClockTime = 0
    end
})

MainTab:CreateSection("Visual Effects")
MainTab:CreateToggle({
    Name = "Full Bright",
    CurrentValue = false,
    Flag = "FullBright",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").Brightness = 1
            game:GetService("Lighting").GlobalShadows = false
        else
            game:GetService("Lighting").Brightness = 0
            game:GetService("Lighting").GlobalShadows = true
        end
    end
})

MainTab:CreateToggle({
    Name = "Fog Removal",
    CurrentValue = false,
    Flag = "FogRemoval",
    Callback = function(Value)
        if Value then
            game:GetService("Lighting").FogEnd = 100000
        else
            game:GetService("Lighting").FogEnd = 500
        end
    end
})

MainTab:CreateSection("ESP Features")
local ESPHighlights = {}
local ESPConnections = {}
local function addESP(player)
    if player ~= LocalPlayer and player.Character then
        local highlight = Instance.new("Highlight")
        highlight.FillColor = Color3.fromRGB(255, 0, 0)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = player.Character
        ESPHighlights[player] = highlight
    end
end
local function removeESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
end
local function onPlayerAdded(player)
    player.CharacterAdded:Connect(function(character) addESP(player) end)
    addESP(player)
end
local function setupESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then onPlayerAdded(player) end
    end
    table.insert(ESPConnections, Players.PlayerAdded:Connect(onPlayerAdded))
end
local function cleanupESP()
    for _, player in pairs(Players:GetPlayers()) do removeESP(player) end
    for _, connection in pairs(ESPConnections) do connection:Disconnect() end
    ESPConnections = {}
end
MainTab:CreateToggle({
    Name = "ESP",
    CurrentValue = false,
    Flag = "ESP",
    Callback = function(Value)
        if Value then setupESP() else cleanupESP() end
    end
})

local FarESPLabels = {}
local FarESPConnections = {}
local function addFarESP(player)
    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
        local screenGui = Instance.new("ScreenGui")
        screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
        screenGui.ResetOnSpawn = false
        local label = Instance.new("TextLabel")
        label.Size = UDim2.new(0, 200, 0, 50)
        label.BackgroundTransparency = 1
        label.TextColor3 = Color3.fromRGB(255, 255, 255)
        label.TextStrokeTransparency = 0.5
        label.TextScaled = true
        label.Parent = screenGui
        FarESPLabels[player] = {Gui = screenGui, Label = label}
    end
end
local function removeFarESP(player)
    if FarESPLabels[player] then
        FarESPLabels[player].Gui:Destroy()
        FarESPLabels[player] = nil
    end
end
local function updateFarESP()
    for player, data in pairs(FarESPLabels) do
        if player.Character and player.Character:FindFirstChild("Head") then
            local head = player.Character.Head
            local distance = (LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Head") and (head.Position - LocalPlayer.Character.Head.Position).Magnitude) or math.huge
            if distance > 50 then
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    data.Label.Visible = true
                    data.Label.Position = UDim2.new(0, screenPos.X - 100, 0, screenPos.Y - 25)
                    data.Label.Text = player.Name .. "\n" .. math.floor(distance * 0.28) .. "m"
                else
                    data.Label.Visible = false
                end
            else
                data.Label.Visible = false
            end
        else
            data.Label.Visible = false
        end
    end
end
local function setupFarESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            addFarESP(player)
            player.CharacterAdded:Connect(function() addFarESP(player) end)
        end
    end
    local playerAddedConnection = Players.PlayerAdded:Connect(function(player)
        if player ~= LocalPlayer then
            addFarESP(player)
            player.CharacterAdded:Connect(function() addFarESP(player) end)
        end
    end)
    local updateConnection = RunService.Heartbeat:Connect(updateFarESP)
    table.insert(FarESPConnections, playerAddedConnection)
    table.insert(FarESPConnections, updateConnection)
end
local function cleanupFarESP()
    for _, player in pairs(Players:GetPlayers()) do removeFarESP(player) end
    for _, connection in pairs(FarESPConnections) do connection:Disconnect() end
    FarESPConnections = {}
    FarESPLabels = {}
end
MainTab:CreateToggle({
    Name = "Far ESP",
    CurrentValue = false,
    Flag = "FarESP",
    Callback = function(Value)
        if Value then setupFarESP() else cleanupFarESP() end
    end
})

MainTab:CreateSection("Aimbot")
MainTab:CreateToggle({
    Name = "Aimbot",
    CurrentValue = false,
    Flag = "Aimbot",
    Callback = function(Value)
        if Value then
            getgenv().AimbotConnection = RunService.RenderStepped:Connect(function()
                local target, minDist = nil, math.huge
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                        local head = player.Character.Head
                        local dist = (Camera.CFrame.Position - head.Position).Magnitude
                        if dist < minDist then
                            minDist = dist
                            target = head
                        end
                    end
                end
                if target then
                    Camera.CFrame = CFrame.new(Camera.CFrame.Position, target.Position)
                end
            end)
        else
            if getgenv().AimbotConnection then
                getgenv().AimbotConnection:Disconnect()
                getgenv().AimbotConnection = nil
            end
        end
    end
})

MainTab:CreateSection("Miscellaneous")
MainTab:CreateButton({
    Name = "Kill All",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChildOfClass("Humanoid") then
                player.Character.Humanoid.Health = 0
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Character",
    Callback = function()
        LocalPlayer.Character:BreakJoints()
    end
})

MainTab:CreateToggle({
    Name = "Fast Respawn",
    CurrentValue = false,
    Flag = "FastRespawn",
    Callback = function(Value)
        if Value then
            getgenv().FastRespawnConnection = LocalPlayer.CharacterAdded:Connect(function(char)
                char:WaitForChild("Humanoid").Died:Connect(function()
                    game:GetService("ReplicatedStorage").Events.Respawn:FireServer()
                end)
            end)
        else
            if getgenv().FastRespawnConnection then
                getgenv().FastRespawnConnection:Disconnect()
                getgenv().FastRespawnConnection = nil
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "Hitbox Size",
    Range = {1, 10},
    Increment = 1,
    Suffix = "Size",
    CurrentValue = 1,
    Flag = "HitboxSize",
    Callback = function(Value)
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                player.Character.Head.Size = Vector3.new(Value, Value, Value)
                player.Character.Head.Transparency = 0.5
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Hitbox",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("Head") then
                player.Character.Head.Size = Vector3.new(1, 1, 1)
                player.Character.Head.Transparency = 0
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "No Clip for Others",
    CurrentValue = false,
    Flag = "NoClipOthers",
    Callback = function(Value)
        if Value then
            getgenv().NoClipOthersConnection = RunService.Stepped:Connect(function()
                for _, player in pairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in pairs(player.Character:GetDescendants()) do
                            if part:IsA("BasePart") then part.CanCollide = false end
                        end
                    end
                end
            end)
        else
            if getgenv().NoClipOthersConnection then
                getgenv().NoClipOthersConnection:Disconnect()
                getgenv().NoClipOthersConnection = nil
            end
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    for _, part in pairs(player.Character:GetDescendants()) do
                        if part:IsA("BasePart") then part.CanCollide = true end
                    end
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Freeze All",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = true
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Unfreeze All",
    Callback = function()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= LocalPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
                player.Character.HumanoidRootPart.Anchored = false
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Loop Teleport to Spawn",
    CurrentValue = false,
    Flag = "LoopTPToSpawn",
    Callback = function(Value)
        if Value then
            getgenv().LoopTPToSpawnConnection = RunService.Heartbeat:Connect(function()
                LocalPlayer.Character.HumanoidRootPart.CFrame = game:GetService("Workspace").SpawnLocation.CFrame
            end)
        else
            if getgenv().LoopTPToSpawnConnection then
                getgenv().LoopTPToSpawnConnection:Disconnect()
                getgenv().LoopTPToSpawnConnection = nil
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Auto Heal",
    CurrentValue = false,
    Flag = "AutoHeal",
    Callback = function(Value)
        if Value then
            getgenv().AutoHealConnection = RunService.Heartbeat:Connect(function()
                local character = LocalPlayer.Character
                if character and character:FindFirstChildOfClass("Humanoid") then
                    character.Humanoid.Health = character.Humanoid.MaxHealth
                end
            end)
        else
            if getgenv().AutoHealConnection then
                getgenv().AutoHealConnection:Disconnect()
                getgenv().AutoHealConnection = nil
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Remove Tools",
    Callback = function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then tool:Destroy() end
            end
        end
        local character = LocalPlayer.Character
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then tool:Destroy() end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Give All Tools",
    Callback = function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        if backpack then
            for _, tool in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                if tool:IsA("Tool") then
                    tool:Clone().Parent = backpack
                end
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Loop Give Tools",
    CurrentValue = false,
    Flag = "LoopGiveTools",
    Callback = function(Value)
        if Value then
            getgenv().LoopGiveToolsConnection = RunService.Heartbeat:Connect(function()
                local backpack = LocalPlayer:FindFirstChild("Backpack")
                if backpack then
                    for _, tool in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
                        if tool:IsA("Tool") then
                            tool:Clone().Parent = backpack
                        end
                    end
                end
            end)
        else
            if getgenv().LoopGiveToolsConnection then
                getgenv().LoopGiveToolsConnection:Disconnect()
                getgenv().LoopGiveToolsConnection = nil
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Destroy All Tools in Game",
    Callback = function()
        for _, tool in pairs(game:GetService("ReplicatedStorage"):GetChildren()) do
            if tool:IsA("Tool") then tool:Destroy() end
        end
    end
})

MainTab:CreateToggle({
    Name = "Invisible Tools",
    CurrentValue = false,
    Flag = "InvisibleTools",
    Callback = function(Value)
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        if Value then
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Transparency = 1
                    end
                end
            end
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Transparency = 1
                    end
                end
            end
        else
            if backpack then
                for _, tool in pairs(backpack:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Transparency = 0
                    end
                end
            end
            if character then
                for _, tool in pairs(character:GetChildren()) do
                    if tool:IsA("Tool") and tool:FindFirstChild("Handle") then
                        tool.Handle.Transparency = 0
                    end
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Increase Tool Range",
    Callback = function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.GripPos = Vector3.new(0, 0, 10)
                end
            end
        end
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.GripPos = Vector3.new(0, 0, 10)
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Reset Tool Range",
    Callback = function()
        local backpack = LocalPlayer:FindFirstChild("Backpack")
        local character = LocalPlayer.Character
        if backpack then
            for _, tool in pairs(backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.GripPos = Vector3.new(0, 0, 0)
                end
            end
        end
        if character then
            for _, tool in pairs(character:GetChildren()) do
                if tool:IsA("Tool") then
                    tool.GripPos = Vector3.new(0, 0, 0)
                end
            end
        end
    end
})

MainTab:CreateSection("Game Modifications")
MainTab:CreateButton({
    Name = "Unlock Workspace",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Locked = false
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Destroy All Walls",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") and obj.Name:lower():find("wall") then
                obj:Destroy()
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Increase Part Transparency",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Transparency = math.min(obj.Transparency + 0.1, 1)
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Decrease Part Transparency",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                obj.Transparency = math.max(obj.Transparency - 0.1, 0)
            end
        end
    end
})

MainTab:CreateToggle({
    Name = "Highlight Valuables",
    CurrentValue = false,
    Flag = "HighlightValuables",
    Callback = function(Value)
        if Value then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and (obj.Name:lower():find("coin") or obj.Name:lower():find("gem")) then
                    local highlight = Instance.new("Highlight")
                    highlight.FillColor = Color3.fromRGB(0, 255, 0)
                    highlight.FillTransparency = 0.5
                    highlight.Parent = obj
                end
            end
        else
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("BasePart") and obj:FindFirstChildOfClass("Highlight") then
                    obj:FindFirstChildOfClass("Highlight"):Destroy()
                end
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Teleport to Random Part",
    Callback = function()
        local parts = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("BasePart") then
                table.insert(parts, obj)
            end
        end
        if #parts > 0 then
            local randomPart = parts[math.random(1, #parts)]
            LocalPlayer.Character.HumanoidRootPart.CFrame = randomPart.CFrame + Vector3.new(0, 5, 0)
        end
    end
})

MainTab:CreateButton({
    Name = "Increase Game Speed",
    Callback = function()
        game:GetService("RunService"):Set3dRenderingEnabled(false)
    end
})

MainTab:CreateButton({
    Name = "Reset Game Speed",
    Callback = function()
        game:GetService("RunService"):Set3dRenderingEnabled(true)
    end
})

MainTab:CreateSection("Player Effects")
MainTab:CreateButton({
    Name = "Add Fire Effect",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local fire = Instance.new("Fire")
            fire.Size = 5
            fire.Parent = character.HumanoidRootPart
        end
    end
})

MainTab:CreateButton({
    Name = "Remove Fire Effect",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character.HumanoidRootPart:FindFirstChildOfClass("Fire") then
            character.HumanoidRootPart:FindFirstChildOfClass("Fire"):Destroy()
        end
    end
})

MainTab:CreateButton({
    Name = "Add Sparkles",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local sparkles = Instance.new("Sparkles")
            sparkles.Parent = character.HumanoidRootPart
        end
    end
})

MainTab:CreateButton({
    Name = "Remove Sparkles",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character.HumanoidRootPart:FindFirstChildOfClass("Sparkles") then
            character.HumanoidRootPart:FindFirstChildOfClass("Sparkles"):Destroy()
        end
    end
})

MainTab:CreateButton({
    Name = "Add Smoke",
    Callback = function()
        local character = LocalPlayer.Character
        if character then
            local smoke = Instance.new("Smoke")
            smoke.Opacity = 0.5
            smoke.Parent = character.HumanoidRootPart
        end
    end
})

MainTab:CreateButton({
    Name = "Remove Smoke",
    Callback = function()
        local character = LocalPlayer.Character
        if character and character.HumanoidRootPart:FindFirstChildOfClass("Smoke") then
            character.HumanoidRootPart:FindFirstChildOfClass("Smoke"):Destroy()
        end
    end
})

MainTab:CreateSection("Audio Modifications")
MainTab:CreateButton({
    Name = "Mute All Sounds",
    Callback = function()
        for _, sound in pairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 0
            end
        end
    end
})

MainTab:CreateButton({
    Name = "Unmute All Sounds",
    Callback = function()
        for _, sound in pairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.Volume = 1
            end
        end
    end
})

MainTab:CreateSlider({
    Name = "Sound Pitch",
    Range = {0.5, 2},
    Increment = 0.1,
    Suffix = "Pitch",
    CurrentValue = 1,
    Flag = "SoundPitch",
    Callback = function(Value)
        for _, sound in pairs(game:GetDescendants()) do
            if sound:IsA("Sound") then
                sound.PlaybackSpeed = Value
            end
        end
    end
})

MainTab:CreateSection("Camera Effects")
MainTab:CreateToggle({
    Name = "Third Person View",
    CurrentValue = false,
    Flag = "ThirdPersonView",
    Callback = function(Value)
        if Value then
            Camera.CameraType = Enum.CameraType.Scriptable
            Camera.CFrame = Camera.CFrame * CFrame.new(0, 2, 5)
        else
            Camera.CameraType = Enum.CameraType.Custom
        end
    end
})

MainTab:CreateSlider({
    Name = "Camera Shake",
    Range = {0, 10},
    Increment = 1,
    Suffix = "Shake",
    CurrentValue = 0,
    Flag = "CameraShake",
    Callback = function(Value)
        local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if humanoid then
            humanoid.CameraOffset = Vector3.new(math.random(-Value, Value) / 10, math.random(-Value, Value) / 10, 0)
        end
    end
})

MainTab:CreateSection("Network")
MainTab:CreateButton({
    Name = "Lag Server",
    Callback = function()
        while true do
            for i = 1, 1000 do
                game:GetService("ReplicatedStorage"):WaitForChild("DefaultChatSystemChatEvents").SayMessageRequest:FireServer("Lag", "All")
            end
            wait(1)
        end
    end
})

MainTab:CreateButton({
    Name = "Rejoin Server",
    Callback = function()
        game:GetService("TeleportService"):Teleport(game.PlaceId, LocalPlayer)
    end
})

MainTab:CreateButton({
    Name = "Server Hop",
    Callback = function()
        local servers = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/" .. game.PlaceId .. "/servers/Public?sortOrder=Asc&limit=100"))
        local serverId = servers.data[math.random(1, #servers.data)].id
        game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, serverId, LocalPlayer)
    end
})

local OtherHubsScripts = {
    {Name = "Vortex Hub", URL = "https://raw.githubusercontent.com/xyz/vortex.lua"},
    {Name = "Eclipse Hub", URL = "https://raw.githubusercontent.com/xyz/eclipse.lua"},
    {Name = "Phantom Hub", URL = "https://raw.githubusercontent.com/xyz/phantom.lua"}
}

for _, script in ipairs(OtherHubsScripts) do
    OtherHubsTab:CreateButton({
        Name = "Load " .. script.Name,
        Callback = function()
            local success, err = pcall(function() loadstring(game:HttpGet(script.URL))() end)
            Rayfield:Notify({
                Title = script.Name,
                Content = success and "Successfully loaded " .. script.Name .. "!" or "Failed to load: " .. err,
                Duration = 5,
                Image = 4483362458
            })
        end
    })
end

Rayfield:Notify({Title = "doxxswag Hub Loaded", Content = "Welcome to doxxswag Hub!", Duration = 5, Image = 4483362458})
